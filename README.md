# BBServices

BBServices is a lightweight service object which allows you to create re-usable, easily tested coded. It is designed to be used with Rails / ActiveRecord but can be used as a stand-alone service provider if required.

## Quick Links

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Services Without Rails](#using-without-rails-activerecord)
- [Services With Rails](#using-with-rails-activerecord)
- [Extending Services](#extending-services)
- [Safe vs Unsafe Execution](#safe-vs-unsafe-execution)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bbservices'
```

## Usage

### Quick Start

#### Using without Rails / ActiveRecord

To use `BBServices` without Rails as a standalone service framework, simply create a new class, extend it with `BBServices::Service` and override the following functionality

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

You can then call the service via the class method of run / run! and pass in a block to

```
MyService.run do |service|

end
```

Or you can use any of the following syntax

```
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
```
service.run?
```

Check the overall completion state of the service
```
service.successful?
service.succeeded?
service.failed?
```


Check the completion state via block
```
service.success {  }
service.failure {  }
```

Check for errors, get the errors
```
service.errors?
service.errors
```

#### Using with Rails / ActiveRecord

To use `BBServices` with Rails there is four major classes involved and these are:

  - `BBServices::Rails::New`
  - `BBServices::Rails::Create`
  - `BBServices::Rails::Edit`
  - `BBServices::Rails::Destroy`

and as you can see each of them revolves around the CRUD functionality which Rails offers.

##### BBServices::Rails::ServiceProvider

There are multiple ways to call / use services but for the most part we would recommend using the `BBServices::Rails::ServiceProvider` which can be added as a concern to any controller like so

```
class UsersController < ActionController::Base
  include BBServices::Rails::ServiceProvider
end
```

This will in turn give you access to the following methods which will allow you to run a service, be that a provided service or your own custom services. See [Extending Services](#extending-services) for more information.

  - `service` - Creates a service of a given type
  - `run_service` - Creates & Runs a service of given type
  - `run_service!` - Creates & Runs a service of given type
  - `service_resource` - Allows direct access to the services resourse. This is registered as a Rails helper method when inside a ActionController

##### BBServices::Rails::New

The `BBServices::Rails::New` service acts as a wrapper around any functionality which is normally handled when building a Rails Models, whether this be to return to the front-end via a `GET /new` route or if its going to be saved to the database via a `POST /` route.

#### Extending Services

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

- Rspec Test Helpers
- Mintest Test Helpers
- Completion of Index, Delete Services

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
