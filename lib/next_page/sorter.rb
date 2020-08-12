# frozen_string_literal: true

require 'next_page/sort/name_evaluator'
require 'next_page/sort/segment_parser'
require 'next_page/sort/sort_builder'

module NextPage
  # = Sorter
  #
  # Class Sorter reads the sort parameter and applies the related ordering. Results for each parameter string are
  # cached so evaluation only occurs once.
  class Sorter
    # Initializes a new sorter. The given model is used to validate sort attributes as well as build nested sorts.
    def initialize(model)
      @model = model
      @cache = Hash.new { |hash, key| hash[key] = build_sort(key) }
    end

    # Adds sorting to given query based upon the param. Returns a new query; the existing query is NOT modified.
    #
    # The +query+ parameter is an ActiveRecord arel or model.
    #
    # The +sort_fields+ parameter is a string that conforms to the JSON-API specification for sorting fields:
    # https://jsonapi.org/format/#fetching-sorting
    def sort(query, sort_fields)
      return from_array(query, sort_fields.split(',')) if sort_fields.include?(',')
      return from_array(query, sort_fields) if sort_fields.is_a? Array

      apply_sort(query, sort_fields)
    end

    private

    def apply_sort(query, key)
      @cache[key].call(query)
    end

    def from_array(query, param)
      param.reduce(query) { |memo, key| apply_sort(memo, key) }
    end

    # returns a lambda that applies the appropriate sort, either from a scope, nested attribute, or attribute
    def build_sort(key)
      ActiveSupport::Notifications.instrument('build_sort.next_page', { key: key }) do
        NextPage::Sort::SortBuilder.new(@model).build(key)
      end
    end
  end
end
