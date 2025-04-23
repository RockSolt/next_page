# frozen_string_literal: true

module NextPage
  # # Pagination
  #
  # Module Pagination provides pagination for ActiveRecord queries. It assigns a limit and offset
  # to the resource query and extends the relation with mixin NextPage::PaginationAttributes.
  #
  #
  # ## Invoking Pagination
  #
  # To paginate a resource pass the resource into method `paginate_resource` then store the return value back in the
  # resource:
  #
  #   @photos = paginate_resource(@photos)
  #
  module Pagination
    extend ActiveSupport::Concern

    class_methods do
      def next_page_paginator # :nodoc:
        @next_page_paginator ||= NextPage::Paginator.new
      end
    end

    def paginate_resource(resource, default_limit: nil)
      self.class.next_page_paginator.paginate_resource(resource, params.fetch(:page, {}), default_limit)
    end
  end
end
