# frozen_string_literal: true

module NextPage
  module Sort
    # = Name Evaluator
    #
    # Determines if a name represents an attribute or a scope, provides mapping if the scope requires a prefix or
    # suffix. Scope is checked first, allowing it to override an attribute of the same name. For scopes, method
    # <tt>directional_scope?</tt> checks to see if the scope is a class method that accepts one parameter; if so, then
    # the scope will be invoked with the direction.
    class NameEvaluator
      attr_reader :scope_name

      def initialize(model, name)
        @model = model
        @name = name.to_s
        evaluate_for_scope
      end

      def scope?
        @scope_name.present?
      end

      # true when scope is class method with one parameter
      def directional_scope?
        return false unless scope?

        @model.method(@scope_name).arity == 1
      end

      def valid_attribute_name?
        @model.attribute_names.include?(@name)
      end

      private

      def evaluate_for_scope
        assign_scope(@name) || assign_prefixed_scope || assign_suffixed_scope
      end

      def assign_scope(potential_scope)
        return if @model.dangerous_class_method?(potential_scope) || !@model.respond_to?(potential_scope)

        @scope_name = potential_scope
      end

      def assign_prefixed_scope
        return unless NextPage.configuration.sort_scope_prefix?

        assign_scope("#{NextPage.configuration.sort_scope_prefix}#{@name}")
      end

      def assign_suffixed_scope
        return unless NextPage.configuration.sort_scope_suffix?

        assign_scope("#{@name}#{NextPage.configuration.sort_scope_suffix}")
      end
    end
  end
end
