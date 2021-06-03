# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices::ServiceProvider do
  class BaseServiceProviderController
    include BBServices::ServiceProvider
  end

  context 'instance methods' do
    subject { BaseServiceProviderController.new }

    describe '.service' do
      it 'should return an instance of the passed service' do
        service = subject.create_service(BBServices::Service)
        expect(service).to be_a(BBServices::Service)
      end

      it 'should allow params to be passed' do
        service = subject.create_service(BBServices::Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      end
    end

    describe '.run_service' do
      it 'should return an instance of the passed service' do
        service = subject.run_service(BBServices::Service)
        expect(service).to be_a(BBServices::Service)
      end

      it 'should allow params to be passed' do
        service = subject.run_service(BBServices::Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      end

      it 'should be successful when ran as a base service' do
        subject.run_service(BBServices::Service) do |service|
          expect(service.successful?).to be(true)
          expect(service.failed?).to be false
        end
      end
    end

    describe '.run_service!' do
      it 'should return an instance of the passed service' do
        service = subject.run_service!(BBServices::Service)
        expect(service).to be_a(BBServices::Service)
      end

      it 'should allow params to be passed' do
        service = subject.run_service!(BBServices::Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      end

      it 'should be successful when ran as a base service' do
        subject.run_service!(BBServices::Service, {}) do |service|
          expect(service.successful?).to be(true)
        end
      end
    end

    describe '.service' do 
      context 'when a service is ran' do 
        before do 
          subject.run_service!(BBServices::Service)
        end

        it 'should assign the service to the provider' do 
          expect(subject.service).to_not be_nil
        end
      end
    end

    describe '.chain_services' do 
      it 'should pass the params through to the given block' do 
        subject.chain_services(params: 111) do |params|
          expect(params[:params]).to eq(111)
        end
      end
  
      it 'should return a ServiceChain' do 
        expect(subject.chain_services {}).to be_a(BBServices::ServiceChain)
      end
    end

    describe '.service_chain' do 
      it 'should return the previously chained service' do 
        subject.chain_services {}

        expect(subject.service_chain {}).to be_a(BBServices::ServiceChain)
      end
    end
  end
end
