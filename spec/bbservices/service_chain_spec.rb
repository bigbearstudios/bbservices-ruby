# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices::ServiceChain do
  class self::UnsuccessfulService < BBServices::Service
    def run_service
      raise 'Unsuccessful Service'
    end
  end


  subject { BBServices::ServiceChain.new }

  describe '.chain' do 
    it 'should return the ServiceChain' do 
      expect(subject.chain { }).to be_a(BBServices::ServiceChain)
    end

    it 'should carry on the chain when a successful service is returned from the block' do 
      subject.chain { BBServices::Service.run }
        .chain { BBServices::Service.run }

      expect(subject.services.length).to be(2)
      expect(subject.services.last.ran?).to be(true)
      expect(subject.services.last.successful?).to be(true)
    end

    it 'should carry on the chain when a successful service is returned from the block' do 
      subject.chain { true }
        .chain { BBServices::Service.run }

      expect(subject.services.length).to be(1)
      expect(subject.services.last.ran?).to be(true)
      expect(subject.services.last.successful?).to be(true)
    end

    it 'should end the chain when a unsuccessful service is returned from the block' do 
      subject.chain { self.class::UnsuccessfulService.run }
        .chain { BBServices::Service.run }

      expect(subject.services.length).to be(1)
      expect(subject.services.last.ran?).to be(true)
      expect(subject.services.last.successful?).to be(false)
    end

    it 'should end the chain when a nil(negative) value is returned from the block' do 
      subject.chain { false }
        .chain { BBServices::Service.run }

      expect(subject.services.length).to be(0)
    end
  end

  describe '.services' do 
    it 'should add a ran service to the services list, when the block returns a BBServices::Service' do 
      expect(subject.services).to be_a(Array)
    end

    it 'should add a ran service to the services list, when the block returns a BBServices::Service' do 
      subject.chain { BBServices::Service.new }
      expect(subject.services.length).to be(1)
    end

    it 'should keep a reference of all of the ran services' do 
      subject.chain { BBServices::Service.run }
        .chain { BBServices::Service.run }
        
      expect(subject.services.length).to be(2)
    end
  end

  describe '.previous_service' do 
    it 'should return nil with no run services' do 
      expect(subject.previous_service).to be_nil
    end
  end

  describe '.succeeded?' do
    it 'should return true on a successful run' do
      subject.chain { BBServices::Service.run }
      expect(subject.succeeded?).to be(true)
    end

    it 'should return false on a unsuccessful run' do
      subject.chain { self.class::UnsuccessfulService.run }

      expect(subject.succeeded?).to be(false)
    end
  end

  describe '.failed?' do
    it 'should return false on a successful run' do
      subject.chain { BBServices::Service.run }
      expect(subject.failed?).to be(false)
    end

    it 'should return true on a unsuccessful run' do
      subject.chain { self.class::UnsuccessfulService.run }
      expect(subject.failed?).to be(true)
    end
  end

  describe '.success' do
    it 'should yield control on a successful run' do
      subject.chain { BBServices::Service.run }
      expect { |b| subject.success(&b) }.to yield_control
    end

    it 'should not yield control on a unsuccessful run' do
      subject.chain { self.class::UnsuccessfulService.run }
      expect { |b| subject.success(&b) }.not_to yield_control
    end
  end

  describe '.failure' do
    it 'should not yield control on a unsuccessful run' do
      subject.chain { BBServices::Service.run }
      expect { |b| subject.failure(&b) }.not_to yield_control
    end

    it 'should yield control on a unsuccessful run' do
      subject.chain { self.class::UnsuccessfulService.run }
      expect { |b| subject.failure(&b) }.to yield_control
    end
  end

  describe '.error?' do
    it 'should return false on a successful run' do
      subject.chain { BBServices::Service.run }
      expect(subject.error?).to be(false)
    end

    it 'should return false on a unsuccessful run' do
      subject.chain { self.class::UnsuccessfulService.run }
      expect(subject.error?).to be(true)
    end
  end

  describe '.error' do
    it 'should return nil when nothing has been ran' do 
      expect(subject.error).to be_nil
    end

    it 'should return nil when no error is thrown' do
      subject.chain { BBServices::Service.run }
      expect(subject.error).to be_nil
    end

    it 'should return the error thrown' do 
      subject.chain { self.class::UnsuccessfulService.run }
      expect(subject.error).to_not be_nil
      expect(subject.error.message).to eq('Unsuccessful Service')
    end
  end

  describe '.on' do 
    it 'should call success on a successful run' do 
      success_proc = Proc.new {}
      failure_proc = Proc.new {}
      expect(success_proc).to receive(:call)
      expect(failure_proc).to_not receive(:call)

      subject.chain { BBServices::Service.run }
      subject.on(success: success_proc, failure: failure_proc)
    end

    it 'should call failure on an unsuccessful run' do
      allow(subject).to receive(:run_service).and_raise('Exception')

      success_proc = Proc.new {}
      failure_proc = Proc.new {}
      expect(success_proc).to_not receive(:call)
      expect(failure_proc).to receive(:call)

      subject.chain { self.class::UnsuccessfulService.run }
      subject.on(success: success_proc, failure: failure_proc)
    end

    it 'should allow a specific syntax' do 
      subject.on(
        success: Proc.new {}, 
        failure: Proc.new {}
      )
    end
  end
end