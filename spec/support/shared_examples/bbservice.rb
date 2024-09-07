# frozen_string_literal: true

RSpec.shared_examples 'is_a_service' do
  it 'should be a BBService' do
    expect(subject).to be_a(BBServices::Service)
  end
end

RSpec.shared_examples 'is_a_successful_service' do
  it 'should be a BBService' do
    expect(subject).to be_a(BBServices::Service)
  end

  it 'should have ran' do
    expect(subject.ran?).to eq(true)
  end

  it 'should have succeeded' do
    expect(subject.succeeded?).to eq(true)
  end

  it 'should not have an error' do
    expect(subject.error?).to eq(false)
    expect(subject.error).to eq(nil)
    expect(subject.errors).to eq([])
  end
end

RSpec.shared_examples 'is_a_failed_service' do |error|
  it 'should be a BBService' do
    expect(subject).to be_a(BBServices::Service)
  end

  it 'should have ran' do
    expect(subject.ran?).to eq(true)
  end

  it 'should have succeeded' do
    expect(subject.succeeded?).to eq(false)
  end

  it 'should have an error' do
    expect(subject.error?).to eq(true)
    expect(subject.error.message).to eq(error)
    expect(subject.errors.map(&:message)).to eq([error])
  end
end