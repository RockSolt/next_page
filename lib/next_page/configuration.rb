# frozen_string_literal: true

module NextPage
  # = Configuration
  #
  # Class Configuration stores the following settings:
  # - sort_scope_prefix
  # - sort_scope_suffix
  #
  # == Sort Scope Prefix
  # Enables client to sort request to be mapped to a scope with a more specific name. For example, given a derived
  # attribute named <tt>status</tt>, the query parameter can be <tt>sort=status</tt> but would map to a more explicitly
  # named scope, such as <tt>sort_by_status</tt> (assuming the <tt>sort_scope_prefix</tt> value is 'sort_by_').
  #
  # == Sort Scope Suffix
  # Enables client to sort request to be mapped to a scope with a more specific name. For example, given a derived
  # attribute named <tt>status</tt>, the query parameter can be <tt>sort=status</tt> but would map to a more explicitly
  # named scope, such as <tt>status_sort</tt> (assuming the <tt>sort_scope_suffix</tt> value is '_sort').
  class Configuration
    attr_reader :sort_scope_prefix, :sort_scope_suffix

    def sort_scope_prefix=(value)
      @sort_scope_prefix = value.to_s
    end

    def sort_scope_prefix?
      @sort_scope_prefix.present?
    end

    def sort_scope_suffix=(value)
      @sort_scope_suffix = value.to_s
    end

    def sort_scope_suffix?
      @sort_scope_suffix.present?
    end
  end
end
