# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices::ServiceChain do
  let(:test_param_one) { 111 }
  let(:test_param_two) { { a: 111 } }

  context 'instance' do
    subject { BBServices::ServiceChain.new }

    describe '#chain' do
      it { expect(subject.chain {}).to be_a(BBServices::ServiceChain) }

      context 'with a non service chain followed by a service chain' do
        let(:service) { TestService.run }

        before do
          subject.chain { true }.chain { service }
        end

        it { expect(subject.services).to eq([service]) }
        it { expect(subject.successful?).to be(true) }
        it { expect(subject.failed?).to be(false) }

        it { expect(subject.services.last.ran?).to be(true) }
        it { expect(subject.services.last.successful?).to be(true) }
        it { expect(subject.services.last.succeeded?).to be(true) }
        it { expect(subject.services.last.failed?).to be(false) }
      end

      context 'with only a non-service chained' do
        before do
          subject.chain { }
        end

        it { expect(subject.services).to eq([]) }
        it { expect(subject.services.last).to be(nil) }
        it { expect(subject.successful?).to be(true) }
        it { expect(subject.succeeded?).to be(true) }
      end

      context 'with a successful service in the chain' do
        before do
          subject.chain { TestService.run }
        end

        it { expect(subject.services.length).to be(1) }
        it { expect(subject.services.last.ran?).to be(true) }
        it { expect(subject.services.last.successful?).to be(true) }
        it { expect(subject.services.last.succeeded?).to be(true) }
        it { expect { |b| subject.success(&b) }.to yield_control }
        it { expect { |b| subject.failure(&b) }.to_not yield_control }
        it { expect(subject.error?).to be(false) }

        describe '#on' do
          let(:success_proc) { proc {} }
          let(:failure_proc) { proc {} }

          it 'should call the failure_proc' do
            expect(success_proc).to receive(:call)
            expect(failure_proc).to_not receive(:call)

            subject.on(success: success_proc, failure: failure_proc)
          end
        end
      end

      context 'with an unsuccessful service in the chain' do
        before do
          subject
            .chain { UnsuccessfulTestService.run }
            .chain { TestService.run }
        end

        it { expect(subject.services.length).to be(1) }
        it { expect(subject.services.last.ran?).to be(true) }
        it { expect(subject.services.last.successful?).to be(false) }
        it { expect(subject.services.last.succeeded?).to be(false) }
        it { expect(subject.errors.length).to be(1) }

        it { expect { |b| subject.success(&b) }.to_not yield_control }
        it { expect { |b| subject.failure(&b) }.to yield_control }
        it { expect(subject.error?).to be(true) }

        describe '#on' do
          let(:success_proc) { proc {} }
          let(:failure_proc) { proc {} }

          it 'should call the failure_proc' do
            expect(failure_proc).to receive(:call)
            expect(success_proc).to_not receive(:call)

            subject.on(success: success_proc, failure: failure_proc)
          end
        end
      end

      context 'with multiple successful services' do
        before do
          subject
            .chain { TestService.run }
            .chain { TestService.run }
            .chain { TestService.run }
            .chain { TestService.run }
        end

        it { expect(subject.services.length).to be(4) }
        it { expect(subject.services.last.ran?).to be(true) }
        it { expect(subject.services.last.successful?).to be(true) }
      end
    end
  end
end
