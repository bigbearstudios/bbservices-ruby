# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices do
  let(:test_param_one) { 111 }
  let(:test_param_two) { { a: 111 } }

  it 'should expose BBServices::Service' do
    expect(BBServices::Service)
  end

  it 'should expose BBService::ServiceProvider' do
    expect(BBServices::ServiceProvider)
  end

  describe '#is_a_service?' do
    it { expect(BBServices.is_a_service?(BBServices::Service.new)).to be(true) }
    it { expect(BBServices.is_a_service?(nil)).to be(false) }
    it { expect(BBServices.is_a_service?([])).to be(false) }
    it { expect(BBServices.is_a_service?("")).to be(false) }
  end

  describe '#is_not_a_service?' do
    it { expect(BBServices.is_not_a_service?(BBServices::Service.new)).to be(false) }
    it { expect(BBServices.is_not_a_service?(nil)).to be(true) }
    it { expect(BBServices.is_not_a_service?([])).to be(true) }
    it { expect(BBServices.is_not_a_service?("")).to be(true) }
  end

  describe '#chain' do
    context 'with the splat operator on the block' do
      it 'should pass an args array through to the block' do
        BBServices.chain(test_param_one, test_param_two) do |*args, chain, previous_service|
          expect(args[0]).to eq(test_param_one)
          expect(args[1]).to eq(test_param_two)
        end
      end
  
      it 'should pass a second arg of "chain" though to the block' do
        BBServices.chain(test_param_one, test_param_two) do |*args, chain, previous_service|
          expect(chain).to be_a(BBServices::ServiceChain)
        end
      end
  
      it 'should pass a third arg of "previous_service" though to the block' do
        BBServices.chain(test_param_one, test_param_two) do |*args, chain, previous_service|
          expect(previous_service).to be_nil
        end
      end
    end

    context 'with seperate params' do
      it 'should pass an args array through to the block' do
        BBServices.chain(test_param_one, test_param_two) do |param_one, param_two, chain, previous_service|
          expect(param_one).to eq(test_param_one)
          expect(param_two).to eq(test_param_two)
        end
      end
  
      it 'should pass a third arg of "chain" though to the block' do
        BBServices.chain(test_param_one, test_param_two) do |param_one, param_two, chain, previous_service|
          expect(chain).to be_a(BBServices::ServiceChain)
        end
      end
  
      it 'should pass a fourth arg of "previous_service" though to the block' do
        BBServices.chain(test_param_one, test_param_two) do |param_one, param_two, chain, previous_service|
          expect(previous_service).to be_nil
        end
      end
    end

    it 'should return a ServiceChain' do
      expect(
        BBServices.chain {  }
      ).to be_a(BBServices::ServiceChain)
    end
  end
end
