# frozen_string_literal: true

require_relative "lib/slurm/version"

Gem::Specification.new do |spec|
  spec.name = "slurm"
  spec.version = Slurm::VERSION
  spec.authors = ["Marek Kasztelnik"]
  spec.email = ["mkasztelnik@gmail.com"]

  spec.summary = "Slurm client for running jobs on HPC infrastructures"
  spec.description = "Run HPC jobs from the local computer without struggles."
  spec.homepage = "https://github.com/cyfronet/slurm"
  spec.license = "MIT"

  spec.files = Dir["lib/**/*", "MIT-LICENSE", "README.md"]

  spec.add_dependency "net-ssh", "~> 7.0"

  spec.add_development_dependency "debug"
  spec.add_development_dependency "mocha"
end
