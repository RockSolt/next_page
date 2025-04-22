# frozen_string_literal: true

module NextPage
  # = Paginator
  #
  # Class Paginator uses the controller information to determine the model and variable name for the
  # request, then applies a limit and offset to the query based upon the parameters or the defaults. It also extends
  # the resource with the NextPage::PaginationAttributes mixin.
  class Paginator
    DEFAULT_LIMIT = 10

    def paginate_resource(data, params, default_limit)
      assign_pagination_attributes(data, params, default_limit || DEFAULT_LIMIT)

      data.limit(data.per_page).offset((data.current_page - 1) * data.per_page)
    end

    def decorate_meta!(options)
      return unless options.is_a?(Hash) && options.key?(:json) && !options[:json].is_a?(Hash)

      resource = options[:json]
      options[:meta] = options.fetch(:meta, {}).merge!(total_pages: resource.total_pages,
                                                       total_count: resource.total_count)
    end

    private

    def assign_pagination_attributes(data, params, default_limit)
      data.extend(NextPage::PaginationAttributes)

      data.per_page = page_size(params[:page], default_limit)
      data.current_page = page_number(params[:page])
    end

    def page_size(page, default_limit)
      if page.present? && page[:size].present?
        page[:size]&.to_i
      else
        default_limit
      end
    end

    def page_number(page)
      if page.present? && page[:number].present?
        page[:number]&.to_i
      else
        1
      end
    end
  end
end
