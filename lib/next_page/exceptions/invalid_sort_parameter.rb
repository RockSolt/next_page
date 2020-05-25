# frozen_string_literal: true

module NextPage
  module Exceptions
    # = Invalid Sort Parameter
    class InvalidSortParameter < NextPage::Exceptions::NextPageError
      def initialize(segment)
        @segment = segment
      end

      def message
        "Invalid sort parameter (#{@segment}). Must be an attribute or scope."
      end
    end
  end
end
