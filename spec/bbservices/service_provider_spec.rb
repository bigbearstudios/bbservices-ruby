# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices::ServiceProvider do
  context 'with an extended TestService' do
    let(:test_param_one) { 111 }

    context 'when included in a new class' do
      subject { BaseServiceProviderTestController.new }

      describe '#service' do
        it 'should be nil by default' do
          expect(subject.service).to be(nil)
        end

        context 'when a service is ran' do
          before do
            subject.run_service!(TestService)
          end

          it 'should assign the service to the provider' do
            expect(subject.service).to_not be_nil
          end
        end
      end

      describe '#run_service' do
        it 'should return an instance of the passed service' do
          expect(subject.run_service(TestService)).to be_a(BBServices::Service)
          expect(subject.run_service(TestService)).to be_a(TestService)
        end

        it 'should forward the params to the created service' do
          subject.run_service(TestService, test_param_one) do |service|
            expect(service.param_one).to be(test_param_one)
          end
        end

        it 'should run the service when called' do
          subject.run_service(TestService) do |service|
            expect(service.ran?).to be(true)
          end
        end
      end

      describe '#run_service!' do
        it 'should return an instance of the passed service' do
          expect(subject.run_service(TestService)).to be_a(BBServices::Service)
          expect(subject.run_service(TestService)).to be_a(TestService)
        end

        it 'should forward the params to the created service' do
          subject.run_service(TestService, test_param_one) do |service|
            expect(service.param_one).to be(test_param_one)
          end
        end

        it 'should run the service when called' do
          subject.run_service(TestService) do |service|
            expect(service.ran?).to be(true)
          end
        end
      end
    end
  end
end