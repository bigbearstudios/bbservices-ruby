# frozen_string_literal: true

require 'spec_helper'

## Developer Notes
## Uses the Test class: WithParamsTestService defined in spec/spec_classes.rb
# RSpec.describe BBServices::Extensions::WithParams do

#   context 'with no params' do
#     subject { WithParamsTestService.new() }

#     describe 'has_params?' do
#       it { expect(subject.send(:has_params?)).to eq(false) }
#     end

#     describe 'number_of_params' do
#       it { expect(subject.send(:number_of_params)).to eq(0) }
#     end
#   end

#   context 'with a hash of params' do
#     subject { WithParamsTestService.new({ param_one: 1, param_two: 2 }) }

#     describe 'has_params?' do
#       it { expect(subject.send(:has_params?)).to eq(true) }
#     end

#     describe 'number_of_params' do
#       it { expect(subject.send(:number_of_params)).to eq(2) }
#     end
#   end

#   context 'with a set of named params' do
#     subject { WithParamsTestService.new(param_one: 1, param_two: 2) }

#     describe 'has_params?' do
#       it { expect(subject.send(:has_params?)).to eq(true) }
#     end

#     describe 'number_of_params' do
#       it { expect(subject.send(:number_of_params)).to eq(2) }
#     end
#   end
# end