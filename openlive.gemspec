# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'openlive/version'

Gem::Specification.new do |spec|
  spec.name          = "openlive"
  spec.version       = Openlive::VERSION
  spec.authors       = ["Robert May"]
  spec.email         = ["rob@piratestudios.co.uk"]

  spec.summary       = %q{An API wrapper for OpenLIVE.}
  spec.homepage      = "https://github.com/piratestudios/openlive"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "faraday", "~> 0.9"
  spec.add_runtime_dependency "gem_config", "~> 0.3"
  spec.add_runtime_dependency "oauth2", "~> 1.2"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
