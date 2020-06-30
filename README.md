# BBServices

BBServices is a lightweight service object which allows you to create re-usable, easily tested coded. It is designed to be used with Rails / ActiveRecord but can be used as a stand-alone service provider if required.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bbservices'
```

## Usage

### Quick Start

#### Using without Rails / ActiveRecord

##### Service Basics

In order to use `BBServices` without Rails / as a standalone service framework, simply create a new class and override the following functionality

```
class MyService < BBServices::Service

  # This method allows you to initialize the service, set any member variables
  # and allocate any objects
  def initialize_service

  end

  ##
  # This method is called when calling 'run' or 'run_service' from a provider.
  # Please See 'safe vs unsafe' execution for more information
  def run_service

  end

  ##
  # This method is called when calling 'run!' or 'run_service!' from a provider.
  # Please See 'safe vs unsafe' execution for more information
  def run_service!

  end
end
```

You can then call the service via the class method of run / run!

```
MyService.run do |service|

end
```

Or you can use any of the following

```
#
service = MyService.run

service = MyService.new
service.run

MyService.new.run do |service|

end

```


```

This will run the service calling, initialize_service, run_service or run_service! and any exceptions will be handled by the service.



#### Using with Rails / ActiveRecord

### Extending Functionality




### In Depth Guide

TODO

### Safe vs Unsafe Execution

BBServices uses a similar concept to Rails / ActiveRecord with its concept of save vs save! where in that one will always return where as the other will throw an exception which then should be handled.

Below are examples of the two concepts at work.

#### Safe - Using run, run_service

#### Unsafe - Using run!, run_service!

## Contributing

- Clone the repository
- Install bundler `gem install bundler`
- Install gems `bundle`
- Write some code
- Create a PR via `https://gitlab.com/big-bear-studios-open-source/bbservices/-/merge_requests`

To run tests: `bundle exec rspec`

To run rubocop: `bundle exec rubocop`

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
