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
    - [Complete Example](#complete-example)
    - [Chaining Services](#chaining-services)
    - [Safe vs Unsafe Execution](#safe-vs-unsafe-execution)
  - [Contributing](#contributing)
    - [Running Tests](#running-tests)
    - [Running Rubocop](#running-rubocop)
    - [Publishing (Required Ruby Gems Access)](#publishing-required-ruby-gems-access)
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
    #Note that an error raise here will result in an unsuccessful run, then error will be saved within the service and can be accessed via service.error
  end

  ##
  # This method is called when calling 'run!' or 'run_service!' from a provider.
  # Please See 'safe vs unsafe' execution for more information
  def run_service!
    #Note that an error raise here will result in an unsuccessful run, the error will also
    #be raised up outside of the service, but it will also be captured by the service and accessable via service.error
  end
end
```

One you have created your service and overriden the run_service OR run_service! methods you can then call the service via the class method of `run` / `run!` and pass in a block if you wish to access the service. Its worth noting here that the return of `run` and `run!` is the BBService itself.

``` ruby
MyService.run do |service|

end
```

Internally this will run the service calling the `initialize_service` method, then `run_service` and will handle the internal state / errors which you can access via the following methods.

Check if the service has been ran:

``` ruby
service.run?
```

Check the overall completion state of the service:

``` ruby
service.successful?
service.succeeded?
service.failed?
```

Check the completion state via block:

``` ruby

#Similar syntax to the format blocks in Rails
#Please note this will cause two if statements to be processed, E.g. one for success, one for failure
service.success { #do things on success }
service.failure { #do things on failure }

#Cheaper programatically but uglier syntax
service.on(
  success: Proc.new { 
    #On Success 
  }, 
  failure: Proc.new { 
    #On Failure 
  }
)

#Using the good old if statement, cheapest in terms of performance but not to everyones taste
if service.success 
  #On Success
else 
  #On Failure
end

```

Check for errors, get the errors:

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

### Complete Example

``` ruby
require 'csv'

class CSVReader < BBServices::Service
  def initialize_service
    @file_path = param_for(:file_path)
  end

  def run_service 
    csv = CSV.read(@file_path)
    csv.each do |row|
      #Do something with each row, any error here will be captured
    end
  end
end
 
CSVReader.run(file_path: 'my_csv_file.csv') do |service| 
  service.success { puts 'CSV was read!' }
  service.failure { puts "CSV Failed to read, this was the error #{ service.error.message }" }
end

```

### Chaining Services

With the entire point behind services being that they should perform a single action, you will no doubt run into the problem of 'How do I chain services?', BBServices has solved this with the `.chain` method when can be used via any service:

```ruby

BBServices.chain(first_name: 'John', last_name: 'Someone') { |params, service_chain| CreatePerson.run(params) }
  .chain(company_name: 666) { |params, service_chain, previous_service| CreateCompany.run(params.merge(creator_id: previous_service.id)) }
  .chain() { |params, service_chain| NotifyPerson.run() }
  .success {  }
  .failure {  }

```

There are a given set of rules which are always followed when using the .chain method.

1. A BBService object can be returned from .chain, this will be stored within the ServiceChain
2. The params value is the value from the current call to .chain
3. Success of the chain will be denoted by, All of the services being successful or All of the chained blocks returning a 'non-nil' value
4. Any failures (E.g. Errors been thrown) will result in the chain stopping
5. Any failures using run! will result in the error being throw and require catching

### Safe vs Unsafe Execution

BBServices uses a similar concept to Rails / ActiveRecord with its concept of save vs save! where in that the first method will capture any exceptions and store them where as the other will throw an exception which then should be handled.

## Contributing

- Clone the repository
- Install bundler `gem install bundler`
- Install gems `bundle`
- Write / push some code
- Create a PR via `https://gitlab.com/big-bear-studios-open-source/bbservices/-/merge_requests`

### Running Tests

``` bash
bundle exec rspec
```

### Running Rubocop

``` bash
bundle exec rubocop
```

### Publishing (Required Ruby Gems Access)

``` bash
gem build bbservices.gemspec
gem push bbservices-*.*.*.gem
```

### Future Development

- Add ability to chain services
- Add complete error handling on overriden methods.
- Rspec Test Helpers

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
