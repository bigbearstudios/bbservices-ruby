require 'bbservices'
require 'spec_helper'

RSpec.describe Service do
  class TestService < Service 

  end

  subject { described_class.new }

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

  describe 'self.run!' do
    it 'should return an instance of the service with the base class' do
      expect(described_class.run!).to be_a(described_class)
    end

    it 'should return an instance of the service with an extended class' do
      expect(TestService.run!).to be_a(TestService)
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
      expect(subject.errors?).to be true
      expect(subject.errors.length).to be 1
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

  describe '.params' do
    it 'should allow access to the params' do
      subject.params = { test: 'test' }
      
      expect(subject.params).not_to be nil
      expect(subject.params).to include(:test)
    end

    it 'should have no default params' do
      expect(subject.params).to be nil
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
    class TestHashService < Service
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
    it 'should not yielf control on a unsuccessful run' do
      subject.run
      expect { |b| subject.failure(&b) }.not_to yield_control
    end

    it 'should yield control on a unsuccessful run' do
      allow(subject).to receive(:run_service).and_raise('Exception')

      subject.run
      expect { |b| subject.failure(&b) }.to yield_control
    end
  end

  describe '.errors?' do
    it 'should return false on a successful run' do
      subject.run
      expect(subject.errors?).to be(false)
    end

    it 'should return false on a unsuccessful run' do
      allow(subject).to receive(:run_service).and_raise('Exception')
      
      subject.run
      expect(subject.errors?).to be(true)
    end
  end

  describe '.params?' do
    it 'should be false without params' do 
      subject.params = nil
      expect(subject.params?).to be(false)
    end

    it 'should be false with params' do
      subject.params = { param: 5 }
      expect(subject.params?).to be(true)
    end
  end

  describe '.ran?' do
    it 'should be false when not ran' do
      expect(subject.ran?).to be false
    end

    it 'should be true when ran' do
      subject.run
      expect(subject.ran?).to be true
    end

    it 'should be true on an unsuccessful run' do
      allow(subject).to receive(:run_service).and_raise('Exception')

      subject.run
      expect(subject.ran?).to be true
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
end
