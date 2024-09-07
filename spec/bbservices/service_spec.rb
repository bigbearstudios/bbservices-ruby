# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BBServices::Service do

  context 'base BBServices::Service' do
    describe '#on_run' do
      it 'should throw a NotImplementedError' do
        expect { BBServices::Service.run }.to raise_error(NotImplementedError)
      end
    end

    describe '#on_run!' do
      it 'should throw a NotImplementedError' do
        expect { BBServices::Service.run! }.to raise_error(NotImplementedError)
      end
    end
  end

  context 'with an extended TestService' do
    let(:test_param) { { a:1 } }

    context 'self.' do
      describe '#new' do
        subject { TestService.new }

        include_examples('is_a_service')
      end
      
      describe '#run' do
        subject { TestService.run(test_param) }

        include_examples('is_a_service')

        it { expect(subject).to be_a(TestService) }
        it { expect(subject.param_one).to eq(test_param) }
        it 'should yield control to the passed block' do
          expect { |b| TestService.run(&b) }.to yield_control
        end
      end

      describe '#run!' do
        subject { TestService.run!(test_param) }

        include_examples('is_a_service')

        it { expect(subject).to be_a(TestService) }
        it { expect(subject.param_one).to eq(test_param) }
        it 'should yield control to the passed block' do
          expect { |b| TestService.run(&b) }.to yield_control
        end
      end
    end

    context 'instance' do
      subject { TestService.new(test_param) }
  
      describe '#run' do
        it 'should yield control to the passed block' do
          expect { |b| subject.run(&b) }.to yield_control
        end

        context 'with a successful run' do
          before { subject.run }

          include_examples('is_a_successful_service')
        end

        context 'with an unsuccessful run' do
          before do
            allow(subject).to receive(:on_run).and_raise(RuntimeError)
            subject.run
          end

          include_examples('is_a_failed_service', 'RuntimeError')
        end
      end
  
      describe '#run!' do
        context 'with a successful run' do
          before { subject.run! }

          include_examples('is_a_successful_service')
        end
  
        it 'should yield control to the passed block' do
          expect { |b| subject.run!(&b) }.to yield_control
        end
  
        it 'should raise the error with an unsuccessful run' do
          allow(subject).to receive(:on_run!).and_raise('Exception')
          expect { subject.run! }.to raise_error(RuntimeError)
        end
      end

      context 'when intialized' do
        describe '#succeeded?' do
          it { expect(subject.succeeded?).to be(false) }
        end

        describe '#successful?' do
          it { expect(subject.successful?).to be(false) }
        end

        describe '#failed?' do
          it { expect(subject.failed?).to be(false) }
        end

        describe '#success' do
          it { expect { |b| subject.success(&b) }.to_not yield_control }
        end

        describe '#failure' do
          it { expect { |b| subject.failure(&b) }.to_not yield_control }
        end

        describe '#error?' do
          it { expect(subject.error?).to be(false) }
        end

        describe '#ran?' do
          it { expect(subject.ran?).to be false }
        end

        describe '#run?' do
          it { expect(subject.run?).to be false }
        end

        describe '#on' do
          let(:success_proc) { proc {} }
          let(:failure_proc) { proc {} }

          it 'should call the neither proc' do
            expect(success_proc).to_not receive(:call)
            expect(failure_proc).to_not receive(:call)

            subject.on(success: success_proc, failure: failure_proc)
          end
        end
      end

      context 'with a successful run' do
        before do
          subject.run
        end

        describe '#succeeded?' do
          it { expect(subject.succeeded?).to be(true) }
        end

        describe '#successful?' do
          it { expect(subject.succeeded?).to be(true) }
        end

        describe '#failed?' do
          it { expect(subject.failed?).to be(false) }
        end

        describe '#success' do
          it { expect { |b| subject.success(&b) }.to yield_control }
        end

        describe '#failure' do
          it { expect { |b| subject.failure(&b) }.to_not yield_control }
        end

        describe '#error?' do
          it { expect(subject.error?).to be(false) }
        end

        describe '#ran?' do
          it { expect(subject.ran?).to be true }
        end

        describe '#run?' do
          it { expect(subject.run?).to be true }
        end

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

      context 'with a successful run, which returns false from on_run' do
        before do
          allow(subject).to receive(:on_run) { false }
          subject.run
        end

        describe '#succeeded?' do
          it { expect(subject.succeeded?).to be(false) }
        end

        describe '#successful?' do
          it { expect(subject.succeeded?).to be(false) }
        end

        describe '#failed?' do
          it { expect(subject.failed?).to be(true) }
        end

        describe '#success' do
          it { expect { |b| subject.success(&b) }.to_not yield_control }
        end

        describe '#failure' do
          it { expect { |b| subject.failure(&b) }.to yield_control }
        end

        describe '#error?' do
          it { expect(subject.error?).to be(false) }
        end

        describe '#ran?' do
          it { expect(subject.ran?).to be true }
        end

        describe '#run?' do
          it { expect(subject.run?).to be true }
        end

        describe '#on' do
          let(:success_proc) { proc {} }
          let(:failure_proc) { proc {} }

          it 'should call the failure_proc' do
            expect(success_proc).to_not receive(:call)
            expect(failure_proc).to receive(:call)

            subject.on(success: success_proc, failure: failure_proc)
          end
        end
      end

      context 'with an unsuccessful run' do
        before do
          allow(subject).to receive(:on_run).and_raise(RuntimeError)
          subject.run
        end

        describe '#succeeded?' do
          it { expect(subject.succeeded?).to be(false) }
        end

        describe '#successful?' do
          it { expect(subject.succeeded?).to be(false) }
        end

        describe '#failed?' do
          it { expect(subject.failed?).to be(true) }
        end

        describe '#success' do
          it { expect { |b| subject.success(&b) }.to_not yield_control }
        end

        describe '#failure' do
          it { expect { |b| subject.failure(&b) }.to yield_control }
        end

        describe '#error?' do
          it { expect(subject.error?).to be(true) }
        end

        describe '#ran?' do
          it { expect(subject.ran?).to be true }
        end

        describe '#run?' do
          it { expect(subject.run?).to be true }
        end

        describe '#on' do
          let(:success_proc) { proc {} }
          let(:failure_proc) { proc {} }

          it 'should call the failure_proc' do
            expect(success_proc).to_not receive(:call)
            expect(failure_proc).to receive(:call)

            subject.on(success: success_proc, failure: failure_proc)
          end
        end
      end
    end
  end

  context 'with an extended NamedTestService' do
    let(:test_param) { { a:1 } }

    context 'self.' do
      describe '#new' do
        it { expect(NamedTestService.new).to be_a(described_class) }
        it { expect(NamedTestService.new(param_one: 'test')).to be_a(described_class) }
      end
      
      describe '#run' do
        context 'with params named' do
          subject { NamedTestService.run(param_one: test_param) }

          include_examples('is_a_service')

          it { expect(subject).to be_a(NamedTestService) }
          it { expect(subject.param_one).to eq(test_param) }
          it { expect { |b| TestService.run(&b) }.to yield_control }
        end

        context 'without named params' do
          subject { NamedTestService.run() }

          include_examples('is_a_service')

          it { expect(subject).to be_a(NamedTestService) }
          it { expect(subject.param_one).to eq(nil) }
          it { expect(subject.param_two).to eq(nil) }
          it { expect { |b| TestService.run(&b) }.to yield_control }
        end
      end

      describe '#run!' do
        subject { NamedTestService.run!(param_one: test_param) }

        include_examples('is_a_service')
        
        it { expect(subject).to be_a(NamedTestService) }
        it { expect(subject.param_one).to eq(test_param) }
        it { expect { |b| NamedTestService.run!(&b) }.to yield_control }
      end
    end
  end
end
