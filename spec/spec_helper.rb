# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_group 'Libraries', '/lib/'
end

require 'bbservices'
require_relative 'support/spec_classes'
require_relative 'support/shared_examples/bbservice'