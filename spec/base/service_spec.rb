require 'spec_helper'

RSpec.describe BBServices::Service, type: :model do
  class self::TestBaseService < BBServices::Service
    service_class Hash
  end

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
    subject { self.class::TestBaseService.new }
    context "with the self.service_class called" do

      it {
        expect(subject.service_class).not_to be nil
      }
    end

    context "with the service_class= called" do
      subject { self.class::TestBaseService.new }

      it {
        subject = BBServices::Service.new
        subject.service_class = Hash

        expect(subject.service_class).not_to be nil
      }
    end
  end

  describe ".succeeded?" do
    it {
      subject.run
      expect(subject.succeeded?).to be true
    }
  end

  describe ".failed?" do
    it {
      subject.run
      expect(subject.failed?).to be false
    }
  end

  describe ".success" do
    it {
      subject.run
      subject.success {

      }
    }
  end

  describe ".failure" do
    before { allow(subject).to receive(:run_service).and_raise("Exception") }
    it {
      subject.run
      subject.failure {

      }
    }
  end
end
