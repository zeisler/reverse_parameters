# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'reverse_parameters/version'

Gem::Specification.new do |spec|
  spec.name          = "reverse_parameters"
  spec.version       = ReverseParameters::VERSION
  spec.authors       = ["Dustin Zeisler"]
  spec.email         = ["dustin@zeisler.net"]

  spec.summary       = %q{Recreate ruby method signatures.}
  spec.description   = %q{Recreate ruby method signatures using ruby's method to Proc creation #method(:method_name).parameters. Use this to dynamically recreate method interfaces.}
  spec.homepage      = "https://github.com/zeisler/reverse_parameters"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.1'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
end
