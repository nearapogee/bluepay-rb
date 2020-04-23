require_relative 'lib/bluepay/version'

Gem::Specification.new do |spec|
  spec.name          = "bluepay-rb"
  spec.version       = Bluepay::VERSION
  spec.authors       = ["Matt Smith"]
  spec.email         = ["matt@nearapogee.com"]

  spec.cert_chain    = ['certs/nearapogee-matt.pem']
  spec.signing_key = File.expand_path("~/.ssh/gem-private_key.pem") if $0 =~ /gem\z/

  spec.summary       = %q{Simple Bluepay API Wrapper}
  spec.description   = %q{Bluepay Payment Gateway API wrapper written for Ruby.}
  spec.homepage      = "https://github.com/nearapogee/bluepay-rb"
  spec.license       = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'binding_of_caller', '~> 0.8.0'
  spec.add_development_dependency 'pry', '~> 0.13.1'
  spec.add_development_dependency 'dotenv', '~> 2.7.5'
end
