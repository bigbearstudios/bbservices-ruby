require 'spec_helper'

RSpec.describe BBServices::Rails::Create, type: :model do
  class CreateServiceTestModelService < BBServices::Rails::Create
     service_class ActiveRecordShim
  end

  subject { CreateServiceTestModelService.new }

  describe ".run" do
    context "with intercepted run_service" do
      before { allow(subject).to receive(:run_service) }
      it {
        subject.run
        expect(subject).to have_received(:run_service)
      }
    end

    context "with base functionality" do
      it {
        subject.run
        expect(subject.succeeded?).to be true
      }
    end
  end

  describe ".run!" do
    context "with intercepted run_service" do
      before { allow(subject).to receive(:run_service!) }
      it {
        subject.run!
        expect(subject).to have_received(:run_service!)
      }
    end

    context "with base functionality" do
      it {
        subject.run!
        expect(subject.succeeded?).to be true
      }
    end
  end

  describe ".object" do
    context "after .run has been called" do
      before { subject.run }
      it {
        expect(subject.resource).to be_instance_of(ActiveRecordShim)
      }
    end

    context "after .run! has been called" do
      before { subject.run! }
      it {
        expect(subject.resource).to be_instance_of(ActiveRecordShim)
      }
    end
  end
end
