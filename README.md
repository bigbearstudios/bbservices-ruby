# BBServices

[![pipeline status](https://gitlab.com/big-bear-studios-open-source/bbservices/badges/master/pipeline.svg)](https://gitlab.com/big-bear-studios-open-source/bbservices/-/commits/master) [![coverage report](https://gitlab.com/big-bear-studios-open-source/bbservices/badges/master/coverage.svg)](https://big-bear-studios-open-source.gitlab.io/bbservices)

BBServices is a lightweight service object which allows you to create re-usable, easily tested coded. It is designed to be used with Rails / ActiveRecord but can be used as a stand-alone service provider if required.

## Table of Contents

- [BBServices](#bbservices)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Quick Start](#quick-start)
    - [Safe vs Unsafe Execution](#safe-vs-unsafe-execution)
  - [Contributing](#contributing)
  - [Future Development](#future-development)
  - [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bbservices'
```

## Usage

### Quick Start

To use `BBServices` without Rails as a standalone service framework, simply create a new class, extend it with `BBServices::Service` and override the following functionality

``` ruby
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

You can then call the service via the class method of run / run! and pass in a block to

``` ruby
MyService.run do |service|

end
```

Or you can use any of the following syntax

``` ruby
# Using the class method of run / run!
service = MyService.run

# Using the .new
service = MyService.new
service.run

# Using the .new with a block
MyService.new.run do |service|

end
```

Internally this will run the service calling the `initialize_service` method, then `run_service` and will handle the internal state / errors which you can access via the following methods

Check if the service has been ran

``` ruby
service.run?
```

Check the overall completion state of the service

``` ruby
service.successful?
service.succeeded?
service.failed?
```

Check the completion state via block

``` ruby
service.success { #do things on success }
service.failure { #do things on failure }
```

Check for errors, get the errors

``` ruby
service.errors?
service.errors
```

### Safe vs Unsafe Execution

BBServices uses a similar concept to Rails / ActiveRecord with its concept of save vs save! where in that one will capture any exceptions and store them where as the other will throw an exception which then should be handled.

## Contributing

- Clone the repository
- Install bundler `gem install bundler`
- Install gems `bundle`
- Write some code
- Create a PR via `https://gitlab.com/big-bear-studios-open-source/bbservices/-/merge_requests`

To run tests: `bundle exec rspec`
To run rubocop: `bundle exec rubocop`

## Future Development

- Add complete error handling on overriden methods. E.g. Handling @object on find / build overrides
- Rspec Test Helpers
- Mintest Test Helpers
- Completion of Index, Delete Services

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
