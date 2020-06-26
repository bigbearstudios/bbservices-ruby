require 'spec_helper'

RSpec.describe BBServices::Service, type: :model do
  subject { BBServices::Service.new }

  describe ".run" do
    context "with intercepted run_service" do
      before { allow(subject).to receive(:run_service) }
      it {
        subject.run
        expect(subject).to have_received(:run_service)
      }
    end

    context "with a block" do
      before { allow(subject).to receive(:run_service) }
      it {
        subject.run do |service|
          expect(subject).to have_received(:run_service)
        end
      }
    end

    context "with base functionality" do
      it {
        subject.run
        expect(subject.succeeded?).to be true
        expect(subject.failed?).to be false
      }
    end

    context "with an exception being thrown" do
      before { allow(subject).to receive(:run_service).and_raise("Exception") }
      it {
        subject.run
        expect(subject).to have_received(:run_service)
        expect(subject.succeeded?).to be false
        expect(subject.has_errors?).to be true
        expect(subject.errors.length).to be 1
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

    context "with a block" do
      before { allow(subject).to receive(:run_service!) }
      it {
        subject.run! do |service|
          expect(subject).to have_received(:run_service!)
        end
      }
    end

    context "with base functionality" do
      it {
        subject.run!
        expect(subject.succeeded?).to be true
      }
    end

    context "with an exception being thrown" do
      before { allow(subject).to receive(:run_service!).and_raise("Exception") }
      it {
        expect{ subject.run! }.to raise_error(RuntimeError)
      }
    end
  end

  describe ".params" do
    context "with assigned params" do
      before { subject.params = { test: "test" } }

      it {
        expect(subject.params).not_to be nil
        expect(subject.params).to include(:test)
      }
    end

    context "with default params" do
      it {
        expect(subject.params).to be nil
      }
    end
  end

  describe ".associated_params" do
    context "with assigned associated_params" do
      before { subject.associated_params = { test: "test" } }

      it {
        expect(subject.associated_params).not_to be nil
        expect(subject.associated_params).to include(:test)
      }
    end

    context "with default associated_params" do
      it {
        expect(subject.associated_params).to be nil
      }
    end
  end

  describe ".param_for" do
    context "with assigned params" do
      before { subject.params = { test: "test" } }

      it {
        expect(subject.param_for(:test)).not_to be nil
        expect(subject.param_for(:test)).to eq("test")
      }
    end

    context "with default params" do
      it {
        expect(subject.param_for(:test)).to be nil
      }
    end
  end

  describe ".associated_param_for" do
    context "with assigned associated_params" do
      before { subject.associated_params = { test: "test" } }

      it {
        expect(subject.associated_param_for(:test)).not_to be nil
        expect(subject.associated_param_for(:test)).to eq("test")
      }
    end

    context "with default associated_params" do
      it {
        expect(subject.associated_param_for(:test)).to be nil
      }
    end
  end

  describe "service_class" do
    class self::TestBaseService < BBServices::Service
      service_class Hash
    end

    subject { self.class::TestBaseService.new }
    context "with the self.service_class called" do

      it {
        expect(subject.service_class).not_to be nil
      }
    end

    context "with the service_class= called" do
      subject { BBServices::Service.new }

      it {
        subject.service_class = Hash
        expect(subject.service_class).not_to be nil
      }
    end
  end

  describe ".succeeded?" do
    context "with successful run" do
      it {
        subject.run
        expect(subject.succeeded?).to be true
      }
    end

    context "with an exception being thrown" do
      before { allow(subject).to receive(:run_service).and_raise("Exception") }
      it {
        subject.run
        expect(subject.succeeded?).to be false
      }
    end
  end

  describe ".failed?" do
    context "with successful run" do
      it {
        subject.run
        expect(subject.failed?).to be false
      }
    end

    context "with an exception being thrown" do
      before { allow(subject).to receive(:run_service).and_raise("Exception") }
      it {
        subject.run
        expect(subject.failed?).to be true
      }
    end
  end

  describe ".success" do
    context "with successful run" do
      it {
        subject.run
        expect { |b| subject.success(&b) }.to yield_control
      }
    end

    context "with an exception being thrown" do
      before { allow(subject).to receive(:run_service).and_raise("Exception") }
      it {
        subject.run
        expect { |b| subject.success(&b) }.not_to yield_control
      }
    end
  end

  describe ".failure" do
    context "with successful run" do
      it {
        subject.run
        expect { |b| subject.failure(&b) }.not_to yield_control
      }
    end

    context "with an exception being thrown" do
      before { allow(subject).to receive(:run_service).and_raise("Exception") }
      it {
        subject.run
        expect { |b| subject.failure(&b) }.to yield_control
      }
    end
  end

  describe ".ran?" do
    context "when not ran" do
      it {
        expect(subject.ran?).to be false
      }
    end

    context "when ran" do
      it {
        subject.run
        expect(subject.ran?).to be true
      }
    end
  end

  describe ".object" do
    it {
      subject.run
      expect(subject.object).to be nil
    }
  end
end
