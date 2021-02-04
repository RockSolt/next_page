# frozen_string_literal: true

module NextPage
  # = Pagination Attributes
  #
  # Module PaginationAttributes adds in methods required for pagination links: previous_page, current_page, next_page,
  # and total_pages. It reads the offset and limit on the query to determine the values.
  #
  # In some cases the query will not support count. In that case, there are two ways to override the default behavior:
  # - provide a count_query that can resolve the attributes
  # - specify the following attributes manually: current_page, total_count, and per_page
  module PaginationAttributes
    attr_writer :count_query, :current_page, :total_count, :per_page

    def previous_page
      current_page > 1 ? current_page - 1 : nil
    end

    def current_page
      @current_page ||= (count_query.offset_value || 0) + 1
    end

    def next_page
      total_pages > current_page ? current_page + 1 : nil
    end

    def total_count
      @total_count ||= count_query.unscope(:limit).unscope(:offset).count
    end

    def total_pages
      total_count.fdiv(per_page).ceil
    end

    def per_page
      @per_page ||= count_query.limit_value
    end

    # checks first to see if an override query has been provided, then fails back to self
    def count_query
      @count_query || self
    end
  end
end
