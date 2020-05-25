# frozen_string_literal: true

module NextPage
  module Exceptions
    # = Invalid Nested Sort
    class InvalidNestedSort < NextPage::Exceptions::NextPageError
      def initialize(model, association)
        @model = model
        @association = association
      end

      def message
        "Invalid nested sort: Unable to find association #{@association} on model #{@model}"
      end
    end
  end
end
