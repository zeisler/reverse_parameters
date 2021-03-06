# ReverseParameters

[![Build Status](https://travis-ci.org/zeisler/reverse_parameters.svg)](https://travis-ci.org/zeisler/reverse_parameters)
[![Code Climate](https://codeclimate.com/github/zeisler/reverse_parameters/badges/gpa.svg)](https://codeclimate.com/github/zeisler/reverse_parameters)
[![Gem Version](https://badge.fury.io/rb/reverse_parameters.svg)](http://badge.fury.io/rb/reverse_parameters)

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
    
# Method arguments are the real values passed to (and received by) the function.
ReverseParameters.new(method(:example_method)).arguments.to_s
  #=> "named_param: named_param"
    
# Method parameters are the names listed in the function definition.
ReverseParameters.new(method(:example_method)).parameters.to_s
  #=> "named_param:"
  
# Source Ruby API
method(:example_method).parameters
  #=> [[:keyreq, :named_param]]
```

### Ruby Refinements

```ruby
require 'reverse_parameters'
using ReverseParameters

def example_method(named_param:)
end
    
# Method arguments are the real values passed to (and received by) the function.
method(:example_method).reverse_parameters.arguments.to_s
  #=> "named_param: named_param"
    
# Method parameters are the names listed in the function definition.
method(:example_method).reverse_parameters.parameters.to_s
  #=> "named_param:"
```

### Monkey Patch to Ruby Core 

*`Method` and `UnboundMethod`*

```ruby
require 'reverse_parameters/core_ext'

def example_method(named_param:)
end
    

method(:example_method).reverse_parameters.arguments.to_s
  #=> "named_param: named_param"
```

To learn more about ruby's parameters method read [Inspecting Method Parameters in Ruby 2.2.3](https://www.rubyplus.com/articles/2721) by RubyPlus.com


## Limitations

It is not possible to get the default values using `Proc#parameters` any optional will default to nil.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/reverse_parameters. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

