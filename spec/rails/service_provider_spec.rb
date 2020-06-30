require 'spec_helper'

RSpec.describe BBServices::Rails::ServiceProvider, type: :model do
  class RailsServiceProviderController
    include BBServices::Rails::ServiceProvider
  end

  context 'instance methods' do
    subject { RailsServiceProviderController.new }

    describe '.run_new_service' do
      it {
        service = subject.run_new_service(ActiveRecordShim)

        expect(service.ran?).to be true
        expect(service.successful?).to be true
      }
    end

    describe '.run_new_service!' do
      it {
        service = subject.run_new_service!(ActiveRecordShim)

        expect(service.ran?).to be true
        expect(service.successful?).to be true
      }
    end

    describe '.run_create_service' do
      it {
        service = subject.run_create_service(ActiveRecordShim)

        expect(service.ran?).to be true
        expect(service.successful?).to be true
      }
    end

    describe '.run_create_service!' do
      it {
        service = subject.run_create_service!(ActiveRecordShim)

        expect(service.ran?).to be true
        expect(service.successful?).to be true
      }
    end

    describe '.service' do
      it {
        service = subject.service(BBServices::Rails::Service)
        expect(service).to be_a(BBServices::Rails::Service)
      }

      it {
        service = subject.service(BBServices::Rails::Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      }

      it {
        service = subject.service(BBServices::Rails::Service, {}, { param: true })
        expect(service.associated_params).to be_a(Hash)
        expect(service.associated_params.length).to be(1)
      }
    end

    describe '.run_service' do
      it {
        service = subject.run_service(BBServices::Rails::Service)
        expect(service).to be_a(BBServices::Rails::Service)
      }

      it {
        service = subject.run_service(BBServices::Rails::Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      }

      it {
        service = subject.run_service(BBServices::Rails::Service, {}, { param: true })
        expect(service.associated_params).to be_a(Hash)
        expect(service.associated_params.length).to be(1)
      }

      it {
        subject.run_service(BBServices::Rails::Service, {}, { param: true }) do |service|
          expect(service.successful?).to be(true)
        end
      }
    end

    describe '.run_service!' do
      it {
        service = subject.run_service!(BBServices::Rails::Service)
        expect(service).to be_a(BBServices::Rails::Service)
      }

      it {
        service = subject.run_service!(BBServices::Rails::Service, { param: true })
        expect(service.params).to be_a(Hash)
        expect(service.params.length).to be(1)
      }

      it {
        service = subject.run_service!(BBServices::Rails::Service, {}, { param: true })
        expect(service.associated_params).to be_a(Hash)
        expect(service.associated_params.length).to be(1)
      }

      it {
        subject.run_service!(BBServices::Rails::Service, {}, { param: true }) do |service|
          expect(service.successful?).to be(true)
        end
      }
    end

    describe '.service_resource' do
      context 'without a ran service' do
        it {
          expect(subject.service_resource).to be nil
        }
      end

      context 'with a new ran service' do
        it {
          subject.run_new_service(ActiveRecordShim)
          expect(subject.service_resource).to be_instance_of(ActiveRecordShim)
        }
      end
    end
  end

  context 'class methods' do
    describe 'register_controller_helper' do
      context 'without a helper_method method' do
        it {
          RailsServiceProviderController.register_controller_helper(:method)
        }
      end

      context 'with a helper_method method' do
        class RailsServiceProviderControllerComplete
          include BBServices::Rails::ServiceProvider

          def self.helper_method(*methods) end
        end

        it {
          RailsServiceProviderControllerComplete.register_controller_helper(:method)
        }
      end
    end
  end
end
