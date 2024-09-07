# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices do
  it 'should expose BBServices::Service' do
    expect(BBServices::Service)
  end

  it 'should expose BBService::ServiceProvider' do
    expect(BBServices::ServiceProvider)
  end

  it 'should expose BBService::ServiceChain' do
    expect(BBServices::ServiceProvider)
  end

  describe '#is_a_service?' do
    it 'should return true for a BBServices::Service' do
      expect(BBServices.is_a_service?(BBServices::Service.new)).to be(true)
    end

    it 'should return false for other types' do
      [nil, [], {}, "", '', 1].each do |obj|
        expect(BBServices.is_a_service?(obj)).to be(false)
      end
    end
  end

  describe '#is_not_a_service?' do
    it 'should return false for a BBServices::Service' do
      expect(BBServices.is_not_a_service?(BBServices::Service.new)).to be(false)
    end

    it 'should return true for other types' do
      [nil, [], {}, "", '', 1].each do |obj|
        expect(BBServices.is_not_a_service?(obj)).to be(true)
      end
    end
  end
end
