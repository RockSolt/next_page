# frozen_string_literal: true

module NextPage
  # # Paginator
  #
  # Class Paginator uses the controller information to determine the model and variable name for the
  # request, then applies a limit and offset to the query based upon the parameters or the defaults. It also extends
  # the resource with the NextPage::PaginationAttributes mixin.
  class Paginator
    DEFAULT_LIMIT = 10

    def paginate_resource(data, params, default_limit)
      default_limit ||= DEFAULT_LIMIT

      assign_pagination_attributes(
        data,
        per_page: params[:size]&.to_i || default_limit,
        current_page: params[:number]&.to_i || 1
      )

      data.limit(data.per_page).offset((data.current_page - 1) * data.per_page)
    end

    private

    def assign_pagination_attributes(data, per_page:, current_page:)
      data.extend(NextPage::PaginationAttributes)

      data.per_page = per_page
      data.current_page = current_page
    end
  end
end
