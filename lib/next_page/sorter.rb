# frozen_string_literal: true

module NextPage
  # = Sorter
  #
  # Class Sorter reads the sort parameter and applies the related ordering. Results for each parameter string are
  # cached so evaluation only occurs once.
  class Sorter
    SEGMENT_REGEX = /(?<sign>[+|-]?)(?<attribute>\w+)/.freeze

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
        if @model.respond_to?(key)
          ->(query) { query.send(key) }
        elsif key.include?('.')
          build_nested_sort(key)
        else
          order_params = directional_attribute(@model, key)
          ->(query) { query.order(order_params) }
        end
      end
    end

    def build_nested_sort(nested_key)
      # remove and capture sign if present
      sign = nil
      if nested_key.start_with?('+', '-')
        sign = nested_key[0]
        nested_key = nested_key[1..-1]
      end

      *associations, key = *nested_key.split('.')
      sort_model = dig_association_model(associations)
      joins = build_joins(associations)
      order_params = directional_attribute(sort_model, "#{sign}#{key}")

      ->(query) { query.joins(joins).merge(sort_model.order(order_params)) }
    end

    # traverse nested associations to find last association's model
    def dig_association_model(associations)
      associations.reduce(@model) do |model, association_name|
        association = model.reflect_on_association(association_name)
        raise NextPage::Exceptions::InvalidNestedSort.new(model, association_name) if association.nil?

        association.klass
      end
    end

    # transform associations array to nested hash
    # ['team'] => [:team]
    # ['team', 'coach'] => { team: :coach }
    def build_joins(associations)
      associations.map(&:to_sym)
                  .reverse
                  .reduce { |memo, association| memo.nil? ? association.to_sym : { association => memo } }
    end

    def directional_attribute(model, segment)
      parsed = segment.match SEGMENT_REGEX
      attribute = parsed['attribute']
      direction = parsed['sign'] == '-' ? 'desc' : 'asc'
      return { attribute => direction } if model.attribute_names.include?(attribute)

      raise NextPage::Exceptions::InvalidSortParameter, segment
    end
  end
end
