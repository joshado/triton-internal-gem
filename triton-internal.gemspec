# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'triton/version'

Gem::Specification.new do |spec|
  spec.name          = "triton-internal"
  spec.version       = Triton::VERSION
  spec.authors       = ["Thomas Haggett"]
  spec.email         = ["thomas-tritongem@haggett.org"]
  spec.licenses      = ['MIT']

  spec.summary       = %q{Library to wrap the Triton internal APIs}
  spec.description   = %q{Library that wraps all of the Joyent Triton Internal APIs in a consistent ruby interface allowing easier calling and mocking.}
  spec.homepage      = "http://thomas.haggett.org/"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir.glob(File.expand_path("../**/*", __FILE__)).reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency 'rest-client', "~> 1.8"
  spec.add_dependency 'socksify', "~> 1.7"
end
