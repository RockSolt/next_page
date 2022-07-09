# frozen_string_literal: true

module NextPage
  # = Pagination
  #
  # Module Pagination provides pagination for index methods. It assigns a limit and offset
  # to the resource query and extends the relation with mixin NextPage::PaginationAttributes.
  #
  # There are two ways to paginate: using a before filter or by calling `paginate_resource` explicitly.
  #
  # == Before Filter
  # Here's an example of using the before filter in a controller:
  #   before_action :apply_next_page_pagination, only: :index
  #
  # This entry point uses the following conventions to apply pagination:
  # - the name of the instance variable is the same as the component (for example PhotosController -> @photos)
  # - the name of the model is the controller name singularized (for example PhotosController -> Photo)
  #
  # Either can be overridden by calling method `paginate_with` in the controller. The two override options are
  # `instance_variable_name` and `model_class`. For example, if the PhotosController used the model Picture and the
  # instance variable name @photographs, the controller declares it as follows:
  #   paginate_with instance_variable_name: :photographs, model_class: 'Picture'
  #
  # If the before filter is used, it will populate an instance variable. The action should NOT reset the variable, as
  # that removes pagination.
  #
  # == Invoking Pagination Directly
  # To paginate a resource pass the resource into method `paginate_resource` then store the return value back in the
  # resource:
  #
  #   @photos = paginate_resource(@photos)
  #
  # == Default Limit
  # The default size limit can be overridden with the `paginate_with` method for either type of pagination. Pass option
  # `default_limit` to specify an override:
  #
  #   paginate_with default_limit: 25
  #
  # All the options can be mixed and matches when calling `paginate_with`:
  #
  #   paginate_with model_class: 'Photo', default_limit: 12
  #   paginate_with default_limit: 12, instance_variable_name: 'data'
  module Pagination
    extend ActiveSupport::Concern

    class_methods do
      def next_page_paginator # :nodoc:
        @next_page_paginator ||= NextPage::Paginator.new(controller_name, controller_path)
      end

      # Configure pagination with any of the following options:
      # - instance_variable_name: explicitly name the variable if it does not follow the convention
      # - model_class: explicitly specify the model name if it does not follow the convention
      # - default_limit: specify an alternate default
      # - default_sort: sort parameter if none provided, use same format as url: created_at OR -updated_at
      def paginate_with(instance_variable_name: nil, model_class: nil, default_limit: nil, default_sort: nil)
        next_page_paginator.paginate_with(instance_variable_name, model_class, default_limit, default_sort)
      end
    end

    # Called with before_action in order to automatically paginate the resource.
    def apply_next_page_pagination
      self.class.next_page_paginator.paginate(self, params.slice(:page, :sort))
    end

    # Invokes pagination directly, the result must be stored as the resource itself is not modified.
    def paginate_resource(resource)
      self.class.next_page_paginator.paginate_resource(resource, params.slice(:page, :sort))
    end

    def render(*args) # :nodoc:
      return super unless action_name == 'index' && request.headers[:Accept] == 'application/vnd.api+json'

      self.class.next_page_paginator.decorate_meta!(args.first)
      super
    rescue StandardError
      super
    end
  end
end
