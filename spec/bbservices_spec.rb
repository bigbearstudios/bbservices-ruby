# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices do
  it 'should expose BBServices::Service' do
    expect(BBServices::Service)
  end

  it 'should expose BBService::ServiceProvider' do
    expect(BBServices::ServiceProvider)
  end

  describe '.chain' do
    it 'should pass the params through to the given block' do
      BBServices.chain(params: 111) do |params|
        expect(params[:params]).to eq(111)
      end
    end

    it 'should return a ServiceChain' do
      expect(BBServices.chain {}).to be_a(BBServices::ServiceChain)
    end
  end
end
