# frozen_string_literal: true

require "open3"

module HPCKit
  module Slurm
    module Backends
      # = Slurm Restd \Local Backend
      #
      # Invokes +cmd+ (by default +slurmrestd+) with given std input and returns
      # stdout. When the exit code is different than 0
      # +Slurm::Backends::ExecutionError+ is raised.
      class Local
        def initialize(cmd = "slurmrestd")
          @cmd = cmd
        end

        # Start invoking +slurmrestd+ commands.
        #
        # Example:
        #   backend = Slurm::Backends::Local.new("echo")
        #   backend.start do |conn|
        #     conn.run("stdin1") #=> "stdin1"
        #     conn.run("stdin2") #=> "stdin2"
        #   end
        def start
          yield Runner.new(@cmd)
        end

        private
          class Runner # :nodoc:
            def initialize(cmd)
              @cmd = cmd
            end

            def run(request)
              output, exit_code = Open3.capture2(@cmd, stdin_data: request)
              raise ExecutionError, "#{@cmd} exited with #{exit_code}" if exit_code != 0

              output
            end
          end
      end
    end
  end
end
