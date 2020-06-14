# frozen_string_literal: true

module NextPage
  # = Paginator
  #
  # Class Paginator uses the controller information to determine the model and variable name for the
  # request, then applies a limit and offset to the query based upon the parameters or the defaults. It also extends
  # the resource with the NextPage::PaginationAttributes mixin.
  #
  # Configuration can be specified in the controller by calling `paginate_with`. The following overrides can be
  # specified if necessary:
  # - default_limit: limit to use if request does not specify (default value is 10)
  # - instance_variable_name: default value is the controller name; for example, @photos in PhotosController
  # - model_class: default derived from controller name (or path if nested); for example, Photo for PhotosController
  class Paginator
    DEFAULT_LIMIT = 10

    def initialize(controller_name, controller_path)
      @controller_name = controller_name
      @controller_path = controller_path

      @default_limit = DEFAULT_LIMIT
    end

    def paginate_with(instance_variable_name, model_class, default_limit, default_sort)
      @default_limit = default_limit if default_limit.present?
      @instance_variable_name = instance_variable_name
      @model_class = model_class.is_a?(String) ? model_class.constantize : model_class
      @default_sort = default_sort
    end

    def paginate(controller, page_params)
      name = "@#{instance_variable_name}"
      data = controller.instance_variable_get(name) || model_class.all

      controller.instance_variable_set(name, paginate_resource(data, page_params))
    end

    def paginate_resource(data, params)
      assign_pagination_attributes(data, params)

      data = sorter.sort(data, params.fetch(:sort, default_sort))
      data.limit(data.per_page).offset((data.current_page - 1) * data.per_page)
    end

    private

    def model_class
      @model_class ||= @controller_name.classify.safe_constantize ||
                       @controller_path.classify.safe_constantize ||
                       raise('Could not determine model for pagination; please specify using `paginate_with` options.')
    end

    def instance_variable_name
      @instance_variable_name ||= @controller_name
    end

    def default_sort
      @default_sort ||= "-#{@model_class.primary_key}"
    end

    def assign_pagination_attributes(data, params)
      data.extend(NextPage::PaginationAttributes)
      data.per_page = page_size(params[:page])
      data.current_page = page_number(params[:page])
    end

    def page_size(page)
      if page.present? && page[:size].present?
        page[:size]&.to_i
      else
        @default_limit
      end
    end

    def page_number(page)
      if page.present? && page[:number].present?
        page[:number]&.to_i
      else
        1
      end
    end

    def sorter
      @sorter ||= NextPage::Sorter.new(model_class)
    end
  end
end
