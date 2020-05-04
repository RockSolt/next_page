# frozen_string_literal: true

module NextPage
  # = Pagination Attributes
  #
  # Module PaginationAttributes adds in methods required for pagination links: current_page, next_page, and total_pages.
  # It reads the offset and limit on the query to determine the values.
  module PaginationAttributes
    def current_page
      @current_page ||= offset_value + 1
    end

    def next_page
      current_page + 1
    end

    def total_pages
      @total_pages ||= unscope(:limit).unscope(:offset).count / per_page
    end

    def per_page
      @per_page ||= limit_value
    end
  end
end
