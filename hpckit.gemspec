# frozen_string_literal: true

require_relative "lib/hpckit/version"

Gem::Specification.new do |spec|
  spec.name = "hpckit"
  spec.version = HPCKit::VERSION
  spec.authors = ["Marek Kasztelnik"]
  spec.email = ["mkasztelnik@gmail.com"]

  spec.summary = "HPCKit makes it easy to interact with the HPC infrastructure via ssh"
  spec.description = "Manage HPC jobs from the local computer without struggles."
  spec.homepage = "https://github.com/cyfronet/hpckit"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*", "MIT-LICENSE", "README.md"]

  spec.add_dependency "net-ssh", "~> 7.0"

  spec.add_development_dependency "debug"
  spec.add_development_dependency "mocha"
end
