# frozen_string_literal: true

require 'next_page/configuration'
require 'next_page/pagination'
require 'next_page/pagination_attributes'
require 'next_page/paginator'

# = Next Page
module NextPage
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
