# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'precis/version'

Gem::Specification.new do |spec|
  spec.name          = "precis"
  spec.version       = Precis::VERSION
  spec.authors       = ["tady"]
  spec.email         = ["tady@zigexn.co.jp"]
  spec.description   = %q{Create summary}
  spec.summary       = %q{Create summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "anemone"
  spec.add_dependency "nokogiri"
  spec.add_dependency "rjb"
  spec.add_dependency "pry-debugger"

end
