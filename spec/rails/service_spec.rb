require 'spec_helper'

RSpec.describe BBServices::Rails::Service, type: :model do
  subject { BBServices::Rails::Service.new }

  describe ".resource" do
    it {
      subject.run
      expect(subject.resource).to be nil
    }
  end
end
