# frozen_string_literal: true

module NextPage
  # = Configuration
  #
  # Class Configuration stores the following settings:
  # - default_per_page
  class Configuration
    attr_accessor :default_per_page

    def initialize
      @default_per_page = 12
    end
  end
end
