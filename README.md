# ReverseParameters

[![Build Status](https://travis-ci.org/zeisler/reverse_parameters.svg)](https://travis-ci.org/zeisler/reverse_parameters)

Recreate ruby method signatures using ruby's method to Proc creation `#method(:method_name).parameters`. Use this to dynamically recreate method parameter interfaces. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'reverse_parameters'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install reverse_parameters

## Usage

```ruby
require 'reverse_parameters'

def example_method(named_param:)
end

parameters = method(:example_method).parameters
  #=> [[:keyreq, :named_param]]
    
# Method arguments are the real values passed to (and received by) the function.
ReverseParameters.arguments(parameters).to_s
  #=> "named_param: named_param"
    
# Method parameters are the names listed in the function definition.
ReverseParameters.parameters(parameters).to_s
  #=> "named_param:"
```

## Limitations

Since it is not possible to get the default values using `Proc#parameters` any optional will default to nil. 
There are no consistent of ways of accurately obtaining that what the optional default value is. 
Since this library's focus is to recreate the public API of a ruby method a default values lies in the private implementation and is out of scope. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/reverse_parameters. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

