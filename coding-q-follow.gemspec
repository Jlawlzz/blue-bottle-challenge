# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bluebottle/version'

Gem::Specification.new do |spec|
  spec.name          = "coding-exercise"
  spec.version       = BlueBottle::VERSION
  spec.authors       = ["Scott Rocher"]
  spec.email         = ["scott@bluebottlecoffee.com"]
  spec.summary       = %q{A coding exercise for engineering candidates at Blue Bottle.}
  spec.description   = %q{Make the tests pass! Model a customer subscription to coffee.}
  spec.homepage      = "https://bluebottlecoffee.com/careers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
