require 'spec_helper'

RSpec.describe BBServices::Service, type: :model do
  subject { BBServices::Service.new }

  describe 'self.run' do
    context 'With the Service base class' do
      it {
        expect(BBServices::Service.run).to be_a(BBServices::Service)
      }

      it {
        service = BBServices::Service.run({ test: 1 })
        expect(service.param_for(:test)).to eq(1)
      }
    end

    context 'with an extended class' do
      it {
        expect(TestService.run).to be_a(TestService)
      }
    end
  end

  describe 'self.run!' do
    context 'With the Service base class' do
      it {
        expect(BBServices::Service.run!).to be_a(BBServices::Service)
      }
    end

    context 'with an extended class' do
      it {
        expect(TestService.run!).to be_a(TestService)
      }
    end
  end

  describe '.run' do
    context 'with intercepted run_service' do
      before { allow(subject).to receive(:run_service) }
      it do
        subject.run
        expect(subject).to have_received(:run_service)
      end
    end

    context 'with a block' do
      before { allow(subject).to receive(:run_service) }
      it {
        expect { |b| subject.run(&b) }.to yield_control
      }
    end

    context 'with base functionality' do
      it {
        subject.run
        expect(subject.succeeded?).to be true
        expect(subject.failed?).to be false
      }
    end

    context 'with an unsuccessful run' do
      before {
        allow(subject).to receive(:run_service).and_raise('Exception')
        subject.run
      }

      it { expect(subject).to have_received(:run_service) }
      it { expect(subject.succeeded?).to be false }
      it { expect(subject.errors?).to be true }
      it { expect(subject.errors.length).to be 1 }
    end
  end

  describe '.run!' do
    context 'with intercepted run_service' do
      before { allow(subject).to receive(:run_service!) }
      it {
        subject.run!
        expect(subject).to have_received(:run_service!)
      }
    end

    context 'with a block' do
      before { allow(subject).to receive(:run_service!) }
      it {
        expect { |b| subject.run!(&b) }.to yield_control
      }
    end

    context 'with base functionality' do
      it {
        subject.run!
        expect(subject.succeeded?).to be true
      }
    end

    context 'with an unsuccessful run' do
      before { allow(subject).to receive(:run_service!).and_raise('Exception') }
      it {
        expect { subject.run! }.to raise_error(RuntimeError)
      }
    end
  end

  describe '.params' do
    context 'with assigned params' do
      before { subject.params = { test: 'test' } }

      it {
        expect(subject.params).not_to be nil
        expect(subject.params).to include(:test)
      }
    end

    context 'with default params' do
      it {
        expect(subject.params).to be nil
      }
    end
  end

  describe '.param_for' do
    context 'with assigned params' do
      before { subject.params = { test: 'test' } }

      it {
        expect(subject.param_for(:test)).not_to be nil
        expect(subject.param_for(:test)).to eq('test')
      }
    end

    context 'with default params' do
      it {
        expect(subject.param_for(:test)).to be nil
      }
    end
  end

  describe 'service_class' do

    subject { TestHashService.new }
    context 'with the self.service_class called' do
      it {
        expect(subject.service_class).not_to be(nil)
        expect(subject.service_class).to be(Hash)
      }
    end

    context 'with the service_class= called' do
      subject { BBServices::Service.new }

      it {
        subject.service_class = Hash
        expect(subject.service_class).not_to be(nil)
        expect(subject.service_class).to be(Hash)
      }
    end
  end

  describe '.succeeded?' do
    context 'with successful run' do
      it {
        subject.run
        expect(subject.succeeded?).to be true
      }
    end

    context 'with an exception being thrown' do
      before { allow(subject).to receive(:run_service).and_raise('Exception') }
      it {
        subject.run
        expect(subject.succeeded?).to be false
      }
    end
  end

  describe '.failed?' do
    context 'with successful run' do
      it {
        subject.run
        expect(subject.failed?).to be false
      }
    end

    context 'with an unsuccessful run' do
      before { allow(subject).to receive(:run_service).and_raise('Exception') }
      it {
        subject.run
        expect(subject.failed?).to be true
      }
    end
  end

  describe '.success' do
    context 'with successful run' do
      it {
        subject.run
        expect { |b| subject.success(&b) }.to yield_control
      }
    end

    context 'with an unsuccessful run' do
      before { allow(subject).to receive(:run_service).and_raise('Exception') }
      it {
        subject.run
        expect { |b| subject.success(&b) }.not_to yield_control
      }
    end
  end

  describe '.failure' do
    context 'with successful run' do
      it {
        subject.run
        expect { |b| subject.failure(&b) }.not_to yield_control
      }
    end

    context 'with an unsuccessful run' do
      before { allow(subject).to receive(:run_service).and_raise('Exception') }
      it {
        subject.run
        expect { |b| subject.failure(&b) }.to yield_control
      }
    end
  end

  describe '.errors?' do
    context 'with successful run' do
      it {
        subject.run
        expect(subject.errors?).to be(false)
      }
    end

    context 'with an unsuccessful run' do
      before { allow(subject).to receive(:run_service).and_raise('Exception') }
      it {
        subject.run
        expect(subject.errors?).to be(true)
      }
    end
  end

  describe '.params?' do
    context 'with no params' do
      it {
        subject.params = nil
        expect(subject.params?).to be(false)
      }
    end

    context 'with params' do
      it {
        subject.params = { param: 5 }
        expect(subject.params?).to be(true)
      }
    end
  end

  describe '.ran?' do
    context 'with no run' do
      it {
        expect(subject.ran?).to be false
      }
    end

    context 'with a successful run' do
      before { subject.run }
      it {
        expect(subject.ran?).to be true
      }
    end

    context 'with an unsuccessful run' do
      before { allow(subject).to receive(:run_service).and_raise('Exception') }
      it {
        subject.run
        expect(subject.ran?).to be true
      }
    end
  end

  describe '.object' do
    context 'when service is not run' do
      it {
        expect(subject.object).to be nil
      }
    end

    context 'when service is run' do
      it {
        subject.run
        expect(subject.object).to be nil
      }
    end
  end
end
