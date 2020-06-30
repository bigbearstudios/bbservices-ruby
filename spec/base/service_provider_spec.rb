require 'spec_helper'

RSpec.describe BBServices::ServiceProvider, type: :model do
  class BaseServiceProviderController
    include BBServices::ServiceProvider
  end

  context 'instance methods' do
    subject { BaseServiceProviderController.new }

    describe '.service' do
      it {
        service = subject.service(BBServices::Service)
        expect(service).to be_a(BBServices::Service)
      }

      it {
        service = subject.service(BBServices::Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      }
    end

    describe '.run_service' do
      it {
        service = subject.run_service(BBServices::Service)
        expect(service).to be_a(BBServices::Service)
      }

      it {
        service = subject.run_service(BBServices::Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      }

      it {
        subject.run_service(BBServices::Service) do |service|
          expect(service.successful?).to be(true)
        end
      }
    end

    describe '.run_service!' do
      it {
        service = subject.run_service!(BBServices::Service)
        expect(service).to be_a(BBServices::Service)
      }

      it {
        service = subject.run_service!(BBServices::Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      }

      it {
        subject.run_service!(BBServices::Service, {}) do |service|
          expect(service.successful?).to be(true)
        end
      }
    end
  end
end
