# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices do
  it 'should expose BBServices::Service' do
    expect(BBServices::Service)
  end

  it 'should expose BBService::ServiceProvider' do
    expect(BBServices::ServiceProvider)
  end
end
