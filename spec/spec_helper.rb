# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_group 'Libraries', '/lib/'
end

require 'bbservices'

class TestService < BBServices::Service
  attr_accessor :param_one, :param_two

  def initialize(param_one = nil, param_two = nil)
    @param_one = param_one
    @param_two = param_two
  end;

  def on_run() end;
  def on_run!() end;
end

class UnsuccessfulTestService < BBServices::Service
  def initialize()

  end;

  def on_run()
    raise Error
  end;

  def on_run!()
    raise Error
  end;
end
