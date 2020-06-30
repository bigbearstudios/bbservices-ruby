require 'spec_helper'

RSpec.describe BBServices::Rails::Service, type: :model do
  subject { BBServices::Rails::Service.new }

  describe 'self.run' do
    context 'With the Service base class' do
      it {
        expect(BBServices::Rails::Service.run).to be_a(BBServices::Rails::Service)
      }
    end

    context 'with an extended class' do
      it {
        expect(TestRailsService.run).to be_a(TestRailsService)
      }
    end
  end

  describe 'self.run!' do
    context 'With the Service base class' do
      it {
        expect(BBServices::Rails::Service.run!).to be_a(BBServices::Rails::Service)
      }
    end
    
    context 'with an extended class' do
      it {
        expect(TestRailsService.run!).to be_a(TestRailsService)
      }
    end
  end

  describe 'service_class' do
    subject { TestHashService.new }
    context 'with the self.service_class called' do

      it {
        expect(subject.service_class).not_to be nil
      }
    end

    context 'with the service_class= called' do
      subject { BBServices::Service.new }

      it {
        subject.service_class = Hash
        expect(subject.service_class).not_to be nil
      }
    end
  end

  describe '.associated_params' do
    context 'with assigned associated_params' do
      before { subject.associated_params = { test: 'test' } }

      it {
        expect(subject.associated_params).not_to be nil
        expect(subject.associated_params).to include(:test)
      }
    end

    context 'with default associated_params' do
      it {
        expect(subject.associated_params).to be nil
      }
    end
  end

  describe '.associated_param_for' do
    context 'with assigned associated_params' do
      before { subject.associated_params = { test: 'test' } }

      it {
        expect(subject.associated_param_for(:test)).not_to be nil
        expect(subject.associated_param_for(:test)).to eq('test')
      }
    end

    context 'with default associated_params' do
      it {
        expect(subject.associated_param_for(:test)).to be nil
      }
    end
  end

  describe '.resource' do
    it {
      subject.run
      expect(subject.resource).to be nil
    }
  end
end
