# frozen_string_literal: true

class HPCKit::Slurm::Backends::Mock
  def initialize
    @conn = Object.new
  end

  def start
    yield @conn
  end

  def expects_submit(response_body)
    expects_post("/slurm/#{version}/job/submit", response_body)
  end

  def expects_get(path, response_body, headers: {})
    @conn.expects(:run).with do |value|
      value.include?("GET #{path} HTTP/1.1") &&
        headers.all? { |k, v| value.include?("#{k}: #{v}") }
    end.returns(response_body)
  end

  def expects_post(path, response_body)
    @conn.expects(:run).with do |value|
      value.include?("POST #{path} HTTP/1.1") &&
        value.include?("Content-Type: application/json") &&
        block_given? ? yield(value) : true
    end.returns(response_body)
  end

  def expects_delete(path, response_body)
    @conn.expects(:run).with do |value|
      value.include?("DELETE #{path} HTTP/1.1")
    end.returns(response_body)
  end

  def expects_raise(exception, message = "return code != 0")
    @conn.expects(:run).raises(HPCKit::Slurm::Backends::ExecutionError, message)
  end

  private
    def version
      HPCKit::Slurm::Client::SLURM_RESTD_VERSION
    end
end
