require 'spec_helper'

RSpec.describe BBServices::Rails::New, type: :model do
  class NewServiceTestModel
    def save
      true
    end

    def save!
      true
    end

    def errors
    end

    def assign_attributes(attr)
    end
  end

  class NewServiceTestModelService < BBServices::Rails::New
     service_class NewServiceTestModel
  end

  subject { NewServiceTestModelService.new }

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

    context "with params" do
      before { subject.params = {} }
      it {
        subject.run!
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
        expect(subject.resource).to be_instance_of(NewServiceTestModel)
      }
    end

    context "after .run! has been called" do
      before { subject.run! }
      it {
        expect(subject.resource).to be_instance_of(NewServiceTestModel)
      }
    end
  end
end
