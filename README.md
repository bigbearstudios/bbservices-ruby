# BBServices

[![pipeline status](https://gitlab.com/big-bear-studios-open-source/bbservices/badges/master/pipeline.svg)](https://gitlab.com/big-bear-studios-open-source/bbservices/-/commits/master) [![coverage report](https://gitlab.com/big-bear-studios-open-source/bbservices/badges/master/coverage.svg)](https://big-bear-studios-open-source.gitlab.io/bbservices)

BBServices is a lightweight service object which allows you to create re-usable and  testable coded. 

## Table of Contents

- [BBServices](#bbservices)
  - [Table of Contents](#table-of-contents)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Quick Start](#quick-start)
    - [Params](#params)
    - [Safe vs Unsafe Execution](#safe-vs-unsafe-execution)
  - [Contributing](#contributing)
  - [Running Tests](#running-tests)
  - [Running Rubocop](#running-rubocop)
    - [Publishing](#publishing)
  - [Future Development](#future-development)
  - [License](#license)

## Installation

Add it to your Gemfile:

``` ruby
gem 'bbservices'
```

Run the following command to install it:

``` bash
bundle install
```

## Usage

### Quick Start

To use `BBServices`, simply create a new class, extend it with `BBServices::Service` and override the following functionality

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
    #Note that an error raise here will result in an unsuccessful run
  end

  ##
  # This method is called when calling 'run!' or 'run_service!' from a provider.
  # Please See 'safe vs unsafe' execution for more information
  def run_service!
    #Note that an error raise here will result in an unsuccessful run, the error will also
    #be raised up outside of the service
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
service.error?
service.error
```

### Params

The only parameters that the run method takes is a hash of 'params'. These are passed directly to the service and will be accessble internally via the following methods:

``` ruby
#Called with:
MyService.run(first_name: 'John', last_name: 'Griswald')


class MyService < BBServices::Service
  def run_service
    param_for(:first_name) #John 
    param(:first_name) #John

    params #{ first_name => 'John', last_name => 'Griswald' }

    number_of_params #2
  end
end
```

### Safe vs Unsafe Execution

BBServices uses a similar concept to Rails / ActiveRecord with its concept of save vs save! where in that the first method will capture any exceptions and store them where as the other will throw an exception which then should be handled.

## Contributing

- Clone the repository
- Install bundler `gem install bundler`
- Install gems `bundle`
- Write / push some code
- Create a PR via `https://gitlab.com/big-bear-studios-open-source/bbservices/-/merge_requests`

## Running Tests

``` bash
bundle exec rspec
```

## Running Rubocop

``` bash
bundle exec rubocop
```

### Publishing

``` bash
gem build bbservices.gemspec
gem push bbservices-*.*.*.gem
```

## Future Development

- Add complete error handling on overriden methods.
- Rspec Test Helpers
- Mintest Test Helpers

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
