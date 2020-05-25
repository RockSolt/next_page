# frozen_string_literal: true

module NextPage
  module Exceptions
    class NextPageError < StandardError
    end
  end
end

require 'next_page/exceptions/invalid_nested_sort'
require 'next_page/exceptions/invalid_sort_parameter'
