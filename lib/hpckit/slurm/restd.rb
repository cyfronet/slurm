# frozen_string_literal: true

require "stringio"
require "net/http"

module HPCKit::Slurm
  # = Slurm \Restd
  #
  # +slurmrestd+ client via different backends. By the backend we understand a
  # class which is able to pass raw http request to the +slurmrestd+ command
  # (via standard input) and returns produced raw http response.
  #
  # Client has 2 modes on how it can operate:
  #
  # 1. Single command with a dedicated backend connection (e.g. when
  # +Slurm::Backends::Netssl+ backend is used ssh connection will be established
  # each time request is made):
  #
  #    backend = ...
  #    client = Slurm::Restd.new(backend)
  #
  #    client.get("my/path", header: :value)
  #    client.head("my/path", header: :value)
  #    client.post("my/path", "body", header: :value)
  #    client.patch("my/path", "body", header: :value)
  #    client.put("my/path", "body", header: :value)
  #    client.delete("my/path", header: :value)
  #
  # 2. Shared connection:
  #
  #    backend = ...
  #    Slurm::Restd.new(backend).start do |conn|
  #      conn.get("my/path", header: :value)
  #      conn.head("my/path", header: :value)
  #      conn.post("my/path", "body", header: :value)
  #      conn.patch("my/path", "body", header: :value)
  #      conn.put("my/path", "body", header: :value)
  #      conn.delete("my/path", header: :value)
  #    end
  class Restd
    HTTP_VERSION = "1.1"

    # Create new slurm restd client.
    #
    # === Options
    # +backend+ object responsible for establishing connection to +slurmrestd+.
    #
    # Following backends are available:
    #   [+Slurm::Backends::Local+] It invokes +slurmrestd+ locally. This is the
    #   default value when backend is not given while creating the client.
    #
    #   [+Slurm::Backends::Netssh+] It connects to the remote server via +ssh+
    #   and invokes +slurmrestd+ there. It can use your ssh key or you can pass
    #   username/password.
    def initialize(backend = HPCKit::Slurm::Backends::Local.new)
      @backend = backend
    end

    def get(path, initheader = nil)
      start { |conn| return conn.get(path, initheader) }
    end

    def head(path, initheader = nil)
      start { |conn| return conn.head(path, initheader) }
    end

    def post(path, data, initheader = nil)
      start { |conn| return conn.post(path, data, initheader) }
    end

    def patch(path, data, initheader = nil)
      start { |conn| return conn.patch(path, data, initheader) }
    end

    def put(path, data, initheader = nil)
      start { |conn| return conn.put(path, data, initheader) }
    end

    def delete(path, initheader = nil)
      start { |conn| return conn.delete(path, initheader) }
    end

    # Establish connection to the remote server. When the connection cannot be
    # established +Slurm::Backends::AuthenticationError+ is thrown.
    #
    # In the scope of one connection many slurm operations can executed.
    #
    # Example:
    #
    #    backend = ...
    #    client = Slurm::Restd.new(backend) do |conn|
    #      conn.get("my/path", header: :value)
    #      conn.head("my/path", header: :value)
    #      conn.post("my/path", "body", header: :value)
    #      conn.patch("my/path", "body", header: :value)
    #      conn.put("my/path", "body", header: :value)
    #      conn.delete("my/path", header: :value)
    #    end
    #
    # Each +conn+ method can throw +Slurm::Backends::ExecutionError+. This is
    # done when invocation of the +slurmrestd+ method return code is different
    # than +0+.
    def start
      @backend.start do |conn|
        yield Runner.new(conn)
      end
    end

    private
      class Runner # :nodoc:
        def initialize(conn)
          @conn = conn
        end

        def get(path, initheader = nil)
          run Net::HTTP::Get.new(path, initheader)
        end

        def head(path, initheader = nil)
          run Net::HTTP::Head.new(path, initheader)
        end

        def post(path, data, initheader = nil)
          run Net::HTTP::Post.new(path, initheader), data
        end

        def patch(path, data, initheader = nil)
          run Net::HTTP::Patch.new(path, initheader), data
        end

        def put(path, data, initheader = nil)
          run(Net::HTTP::Put.new(path, initheader), data)
        end

        def delete(path, initheader = nil)
          run(Net::HTTP::Delete.new(path, initheader))
        end

        private
          def run(req, body = nil)
            req.set_body_internal(body)
            socket = Net::BufferedIO.new(StringIO.new)
            req.exec(socket, HTTP_VERSION, req.path)

            output = @conn.run(socket.io.string)

            socket = Net::BufferedIO.new(StringIO.new(output))
            res = Net::HTTPResponse.read_new(socket)
            res.decode_content = req.decode_content
            res.uri = req.uri
            res.reading_body(socket, req.response_body_permitted?) {}
            res
          rescue HPCKit::Slurm::Backends::AuthenticationError => e
            Net::HTTPUnauthorized.new(HTTP_VERSION, 401, e.message)
          rescue HPCKit::Slurm::Backends::ExecutionError => e
            Net::HTTPServerError.new(HTTP_VERSION, 500, e.message)
          end
      end
  end
end
