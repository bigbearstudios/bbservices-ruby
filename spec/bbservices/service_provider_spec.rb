# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices::ServiceProvider do
  context 'with an extended service' do
    let(:test_param_one) { 111 }
    let(:test_param_two) { { a: 111 } }

    class BaseServiceProviderController
      include BBServices::ServiceProvider
    end

    context 'instance methods' do
      subject { BaseServiceProviderController.new }

      describe '#service' do
        it 'should be nil by default' do
          expect(subject.service).to be(nil)
        end

        it 'should return an instance of the passed service' do
          service = subject.create_service(TestService)
          expect(subject.service).to be_a(BBServices::Service)
        end
      end

      describe '#run_service' do
        it 'should return an instance of the passed service' do
          service = subject.run_service(TestService)
          expect(service).to be_a(BBServices::Service)
        end

        it 'should pass the parameters to the service instance' do
          service = subject.run_service(TestService, test_param_one)
          expect(service.param_one).to be(test_param_one)
        end

        it 'should run the service when called' do
          subject.run_service(TestService) do |service|
            expect(service.ran?).to be(true)
          end
        end
      end

      describe '#run_service!' do
        it 'should return an instance of the passed service' do
          service = subject.run_service!(TestService)
          expect(service).to be_a(TestService)
        end

        it 'should allow params to be passed' do
          service = subject.run_service!(TestService, test_param_one)
          expect(service.param_one).to be(test_param_one)
        end

        it 'should be successful when ran as a base service' do
          subject.run_service!(TestService, {}) do |service|
            expect(service.ran?).to be(true)
          end
        end
      end

      describe '#service' do
        context 'when a service is ran' do
          before do
            subject.run_service!(TestService)
          end

          it 'should assign the service to the provider' do
            expect(subject.service).to_not be_nil
          end
        end
      end

      describe '#chain_service' do
        it 'should pass the params through to the given block' do
          subject.chain_service(test_param_one, test_param_two) do |*args, service_chain, previous_service|
            expect(args[0]).to eq(test_param_one)
            expect(args[1]).to eq(test_param_two)
          end
        end

        it 'should return a ServiceChain' do
          expect(subject.chain_service { TestService.run() }).to be_a(BBServices::ServiceChain)
        end
      end

      describe '#service_chain' do
        it 'should be nil by default' do
          expect(subject.service_chain).to be(nil)
        end

        it 'should return the previously chained service' do
          subject.chain_service { TestService.run() }

          expect(subject.service_chain).to be_a(BBServices::ServiceChain)
        end
      end
    end
  end
end