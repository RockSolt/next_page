# frozen_string_literal: true

module NextPage
  module Sort
    # = Sort Builder
    class SortBuilder
      def initialize(model)
        @model = model
      end

      # TODO: support passing direction to scope
      def build(segment)
        @parser = NextPage::Sort::SegmentParser.new(segment)

        if @parser.nested?
          build_nested
        else
          build_non_nested
        end
      end

      private

      def build_nested
        sort_model = dig_association_model(@parser.associations)
        joins = build_joins(@parser.associations)
        evaluator = NextPage::Sort::NameEvaluator.new(sort_model, @parser.name)

        if evaluator.scope?
          build_nested_scope_sort(sort_model, joins, evaluator)
        elsif evaluator.valid_attribute_name?
          nested_attribute_sort(sort_model, joins, @parser.attribute_with_direction)
        else
          raise NextPage::Exceptions::InvalidSortParameter, @parser
        end
      end

      def build_nested_scope_sort(sort_model, joins, evaluator)
        if evaluator.directional_scope?
          nested_directional_scope_sort(sort_model, joins, evaluator.scope_name, @parser.direction)
        else
          nested_scope_sort(sort_model, joins, evaluator.scope_name)
        end
      end

      def nested_attribute_sort(model, joins, attribute_with_direction)
        ->(query) { query.joins(joins).merge(model.order(attribute_with_direction)) }
      end

      def nested_scope_sort(model, joins, scope_name)
        ->(query) { query.joins(joins).merge(model.public_send(scope_name)) }
      end

      def nested_directional_scope_sort(model, joins, scope_name, direction)
        ->(query) { query.joins(joins).merge(model.public_send(scope_name, direction)) }
      end

      def build_non_nested
        evaluator = NextPage::Sort::NameEvaluator.new(@model, @parser.name)

        if evaluator.scope?
          build_non_nested_scope_sort(evaluator)
        elsif evaluator.valid_attribute_name?
          attribute_sort(@parser.attribute_with_direction)
        else
          raise NextPage::Exceptions::InvalidSortParameter, @parser
        end
      end

      def build_non_nested_scope_sort(evaluator)
        if evaluator.directional_scope?
          directional_scope_sort(evaluator.scope_name, @parser.direction)
        else
          scope_sort(evaluator.scope_name)
        end
      end

      def attribute_sort(attribute_with_direction)
        ->(query) { query.order(attribute_with_direction) }
      end

      def scope_sort(scope_name)
        ->(query) { query.send(scope_name) }
      end

      def directional_scope_sort(scope_name, direction)
        ->(query) { query.send(scope_name, direction) }
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

      # TODO: consider prefix / suffix
      def named_scope(sort_model)
        # checking dangerous_class_method? excludes any names that cannot be scope names, such as "name"
        return unless sort_model.respond_to?(@parser.name) && !sort_model.dangerous_class_method?(@parser.name)

        @parser.name
      end
    end
  end
end
