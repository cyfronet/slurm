# frozen_string_literal: true

require_relative "slurm/version"
require_relative "slurm/backends/netssh"
require_relative "slurm/backends/local"
require_relative "slurm/restd"

module Slurm
  class Error < StandardError; end
end
