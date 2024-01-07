# frozen_string_literal: true

#
# A Collection of subclasses which make testing services a little easier.
# There is probably a better way to do this via stubbing but the classes are
# required so frequenty, this seems like an easier way

class TestService < BBServices::Service
  attr_accessor :param_one, :param_two

  def initialize(param_one = nil, param_two = nil)
    @param_one = param_one
    @param_two = param_two
  end

  def on_run() end;
  def on_run!() end;
end

class NamedTestService < BBServices::Service
  attr_accessor :param_one, :param_two

  def initialize(param_one: nil, param_two: nil)
    @param_one = param_one
    @param_two = param_two
  end

  def on_run() end;
  def on_run!() end;
end

class UnsuccessfulTestService < BBServices::Service
  def initialize()

  end

  def on_run()
    raise Error
  end

  def on_run!()
    raise Error
  end
end

class WithParamsTestService < BBServices::Service
  include BBServices::Extensions::WithParams

  def on_run() end;
  def on_run!() end;
end