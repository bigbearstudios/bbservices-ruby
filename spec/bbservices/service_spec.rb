# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices::Service do
  class TestService < BBServices::Service

  end

  context 'self.' do
    describe 'self.run' do
      context 'With the Service base class' do
        it 'should return an instance of the service' do
          expect(described_class.run).to be_a(described_class)
        end

        it 'should allow params to be passed' do
          service = described_class.run({ test: 1 })
          expect(service.param_for(:test)).to eq(1)
        end
      end

      context 'with an extended class' do
        it 'should return an instance of the service' do
          expect(TestService.run).to be_a(TestService)
        end
      end
    end

    describe 'self.call' do
      context 'With the Service base class' do
        it 'should return an instance of the service' do
          expect(described_class.call).to be_a(described_class)
        end

        it 'should allow params to be passed' do
          service = described_class.call({ test: 1 })
          expect(service.param_for(:test)).to eq(1)
        end
      end

      context 'with an extended class' do
        it 'should return an instance of the service' do
          expect(TestService.call).to be_a(TestService)
        end
      end
    end

    describe 'self.run!' do
      it 'should return an instance of the service with the base class' do
        expect(described_class.run!).to be_a(described_class)
      end

      it 'should return an instance of the service with an extended class' do
        expect(TestService.run!).to be_a(TestService)
      end
    end

    describe 'self.call!' do
      it 'should return an instance of the service with the base class' do
        expect(described_class.call!).to be_a(described_class)
      end

      it 'should return an instance of the service with an extended class' do
        expect(TestService.call!).to be_a(TestService)
      end
    end
  end

  context 'on instance' do
    subject { described_class.new }

    describe '.new' do
      it 'should allow no params to be passed' do
        service = described_class.new
        expect(service).to be_a(described_class)
      end

      it 'should allow an hash of params to be passed' do
        service = described_class.new({ test: 'test' })
        expect(service).to be_a(described_class)
        expect(service.number_of_params).to be(1)
      end

      it 'should allow a mapping of params to be passed' do
        service = described_class.new(test: 1, test2: 2)
        expect(service).to be_a(described_class)
        expect(service.number_of_params).to be(2)
      end
    end

    describe '.params=' do
      it 'should throw an exception when a non-hash is passed' do
        expect { subject.params = 'string' }.to raise_error(BBServices::ServiceHashTypeError)
      end

      it 'should throw an exception with a custom message' do
        subject.params = 'string'
      rescue BBServices::ServiceHashTypeError => e
        expect(e.message).to eq('Params need to be a Hash')
      end

      it 'should set the param if given a hash' do
        subject.params = { param: 1 }
        expect(subject.param_for(:param)).to be(1)
      end
    end

    describe '.run' do
      it 'should call the run_service method' do
        allow(subject).to receive(:run_service)
        subject.run
        expect(subject).to have_received(:run_service)
      end

      it 'should yield control to the passed block' do
        allow(subject).to receive(:run_service)
        expect { |b| subject.run(&b) }.to yield_control
      end

      it 'should be successful when ran as a base service' do
        subject.run
        expect(subject.succeeded?).to be true
        expect(subject.failed?).to be false
      end

      it 'should indicate it was unsuccessful' do
        allow(subject).to receive(:run_service).and_raise('Exception')
        subject.run

        expect(subject).to have_received(:run_service)
        expect(subject.succeeded?).to be false
        expect(subject.error?).to be true
      end
    end

    describe '.call' do
      it 'should call the run_service method' do
        allow(subject).to receive(:run_service)
        subject.call
        expect(subject).to have_received(:run_service)
      end
    end

    describe '.run!' do
      it 'should call the run_service method with an intercepted run_service' do
        allow(subject).to receive(:run_service!)
        subject.run!
        expect(subject).to have_received(:run_service!)
      end

      it 'should yield control to the passed block' do
        allow(subject).to receive(:run_service!)
        expect { |b| subject.run!(&b) }.to yield_control
      end

      it 'should be successful when ran as a base service' do
        subject.run!
        expect(subject.succeeded?).to be true
        expect(subject.failed?).to be false
      end

      it 'should raise the error with an unsuccessful run' do
        allow(subject).to receive(:run_service!).and_raise('Exception')
        expect { subject.run! }.to raise_error(RuntimeError)
      end
    end

    describe '.call!' do
      it 'should call the run_service method with an intercepted run_service' do
        allow(subject).to receive(:run_service!)
        subject.call!
        expect(subject).to have_received(:run_service!)
      end
    end

    describe '.params' do
      it 'should allow access to the params' do
        subject.params = { test: 'test' }
        expect(subject.params).not_to be nil
        expect(subject.params).to include(:test)
      end

      it 'should have default params' do
        expect(subject.params).not_to be nil
      end
    end

    describe '.param_for' do
      it 'should allow a set param to be accessed' do
        subject.params = { test: 'test' }
        expect(subject.param_for(:test)).to eq('test')
      end

      it 'should return nil for a param which is not set' do
        expect(subject.param_for(:test)).to be nil
      end
    end

    describe 'service_class' do
      class TestHashService < BBServices::Service
        service_class Hash
      end

      it 'should allow the setting of a service class' do
        expect(TestHashService.new.service_class).to be(Hash)
      end

      it 'should allow the service_class to be set' do
        instance = described_class.new
        instance.service_class = Hash
        expect(instance.service_class).to be(Hash)
      end
    end

    describe '.succeeded?' do
      it 'should return true on a successful run' do
        subject.run
        expect(subject.succeeded?).to be(true)
      end

      it 'should return false on a unsuccessful run' do
        allow(subject).to receive(:run_service).and_raise('Exception')

        subject.run
        expect(subject.succeeded?).to be(false)
      end
    end

    describe '.failed?' do
      it 'should return false on a successful run' do
        subject.run
        expect(subject.failed?).to be(false)
      end

      it 'should return true on a unsuccessful run' do
        allow(subject).to receive(:run_service).and_raise('Exception')

        subject.run
        expect(subject.failed?).to be(true)
      end
    end

    describe '.success' do
      it 'should yield control on a successful run' do
        subject.run
        expect { |b| subject.success(&b) }.to yield_control
      end

      it 'should not yield control on a unsuccessful run' do
        allow(subject).to receive(:run_service).and_raise('Exception')

        subject.run
        expect { |b| subject.success(&b) }.not_to yield_control
      end
    end

    describe '.failure' do
      it 'should not yield control on a unsuccessful run' do
        subject.run
        expect { |b| subject.failure(&b) }.not_to yield_control
      end

      it 'should yield control on a unsuccessful run' do
        allow(subject).to receive(:run_service).and_raise('Exception')

        subject.run
        expect { |b| subject.failure(&b) }.to yield_control
      end
    end

    describe '.error?' do
      it 'should return false on a successful run' do
        subject.run
        expect(subject.error?).to be(false)
      end

      it 'should return false on a unsuccessful run' do
        allow(subject).to receive(:run_service).and_raise('Exception')

        subject.run
        expect(subject.error?).to be(true)
      end
    end

    describe '.params?' do
      it 'should be false with params' do
        subject.params = { param: 5 }
        expect(subject.params?).to be(true)
      end
    end

    describe '.ran?' do
      it 'should be false when not ran' do
        expect(subject.ran?).to be false
        expect(subject.run?).to be false
      end

      it 'should be true when ran' do
        subject.run
        expect(subject.ran?).to be true
        expect(subject.run?).to be true
      end

      it 'should be true on an unsuccessful run' do
        allow(subject).to receive(:run_service).and_raise('Exception')

        subject.run
        expect(subject.ran?).to be true
        expect(subject.run?).to be true
      end
    end

    describe '.object' do
      it 'should be nil by default' do
        expect(subject.object).to be nil
      end

      it 'should be nil when unassigned' do
        subject.run
        expect(subject.object).to be nil
      end
    end

    describe '.on' do
      it 'should call success on a successful run' do
        success_proc = proc {}
        failure_proc = proc {}
        expect(success_proc).to receive(:call)
        expect(failure_proc).to_not receive(:call)

        subject.run
        subject.on(success: success_proc, failure: failure_proc)
      end

      it 'should call failure on an unsuccessful run' do
        allow(subject).to receive(:run_service).and_raise('Exception')

        success_proc = proc {}
        failure_proc = proc {}
        expect(success_proc).to_not receive(:call)
        expect(failure_proc).to receive(:call)

        subject.run
        subject.on(success: success_proc, failure: failure_proc)
      end

      it 'should allow a specific syntax' do
        subject.on(
          success: proc {},
          failure: proc {}
        )
      end
    end
  end
end
