require 'bbservices'
require 'spec_helper'

RSpec.describe ServiceProvider, type: :model do
  class BaseServiceProviderController
    include ServiceProvider
  end

  context 'instance methods' do
    subject { BaseServiceProviderController.new }

    describe '.service' do
      it 'should return an instance of the passed service' do
        service = subject.service(Service)
        expect(service).to be_a(Service)
      end

      it 'should allow params to be passed' do
        service = subject.service(Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      end
    end

    describe '.run_service' do
      it 'should return an instance of the passed service' do
        service = subject.run_service(Service)
        expect(service).to be_a(Service)
      end

      it 'should allow params to be passed' do
        service = subject.run_service(Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      end

      it 'should be successful when ran as a base service' do
        subject.run_service(Service) do |service|
          expect(service.successful?).to be(true)
          expect(service.failed?).to be false
        end
      end
    end

    describe '.run_service!' do
      it 'should return an instance of the passed service' do
        service = subject.run_service!(Service)
        expect(service).to be_a(Service)
      end

      it 'should allow params to be passed' do
        service = subject.run_service!(Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      end

      it 'should be successful when ran as a base service' do
        subject.run_service!(Service, {}) do |service|
          expect(service.successful?).to be(true)
        end
      end
    end
  end
end
