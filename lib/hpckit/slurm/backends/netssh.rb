# frozen_string_literal: true

require "net/ssh"
require "stringio"

module HPCKit
  module Slurm
    module Backends
      # = Slurm Restd \Local Backend
      #
      # Establish ssh connection to the remote host and invoke the slurmrestd
      # commands there.
      class Netssh
        # Create new ssh backend.
        #
        # === Options
        # The same as Net::SSH.start.
        def initialize(host, user = nil, options = {})
          @host = host
          @user = user
          @options = options
        end

        # Establish ssh connection to the remote host and yeild the runner, that
        # should be used to invoke +slurmrestd+ commands.
        #
        # === Examples
        #   backend = Slurm::Backends::Netssh.new("ares.cyfronet.pl")
        #   backend.start do |conn|
        #     conn.run("GET /slurmdb/v0.0.37/job/2357123560 HTTP/1.1\r\n")
        #     conn.run("GET /slurmdb/v0.0.37/job/2357123561 HTTP/1.1\r\n")
        #   end
        def start
          Net::SSH.start(@host, @user, @options) { |ssh| yield Runner.new(ssh) }
        rescue Net::SSH::AuthenticationFailed => e
          raise AuthenticationError, e.message
        end

        private
          class Runner # :nodoc:
            def initialize(ssh)
              @ssh = ssh
            end

            def run(request)
              output = StringIO.new
              exit_code = nil

              @ssh.open_channel do |chan|
                chan.exec "slurmrestd" do |_ch, _success|
                  chan.on_data { |_ch, data| output.write(data) }
                  chan.on_request("exit-status") { |_ch, data| exit_code = data.read_long }

                  chan.send_data request
                  chan.eof!
                end
                chan.wait
              end
              @ssh.loop

              raise ExecutionError, "slurmrestd exited with #{exit_code}" if exit_code != 0

              output.string
            end
          end
      end
    end
  end
end
