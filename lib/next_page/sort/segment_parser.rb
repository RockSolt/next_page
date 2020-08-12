# frozen_string_literal: true

module NextPage
  module Sort
    # = Segment Parser
    #
    # Parses each sort segment to provide direction, associations, and name.
    class SegmentParser
      attr_reader :direction, :associations, :name

      SEGMENT_REGEX = /(?<sign>[+|-]?)(?<names>.+)/.freeze

      def initialize(segment)
        @segment = segment
        parsed = segment.match SEGMENT_REGEX
        @direction = parsed['sign'] == '-' ? 'desc' : 'asc'
        *@associations, @name = *parsed['names'].split('.')
      end

      def to_s
        @segment
      end

      def attribute_with_direction
        { @name => @direction }
      end

      def nested?
        @associations.present?
      end
    end
  end
end
