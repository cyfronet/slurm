# frozen_string_literal: true

require_relative "hpckit/version"
require_relative "hpckit/slurm/backends/netssh"
require_relative "hpckit/slurm/backends/local"
require_relative "hpckit/slurm/restd"
require_relative "hpckit/slurm/script"

module HPCKit
  class Error < StandardError; end
end
