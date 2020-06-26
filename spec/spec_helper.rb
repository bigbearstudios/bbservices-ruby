require 'simplecov'

##
# SimpleCov
SimpleCov.start do
  add_filter 'spec'
end

require 'bbservices'

##
# A simple active record shim used for testing purposes
class ActiveRecordShim

  def self.transaction
    yield
  end

  def save
    true
  end

  def save!
    true
  end

  def errors

  end

  def assign_attributes(attr)

  end
end

RSpec.configure do |config|

end
