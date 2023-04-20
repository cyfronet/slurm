# frozen_string_literal: true

require "test_helper"
require "json"

class Slurm::TestRestd < Minitest::Test
  def setup
    @conn = Object.new
    backend = Object.new
    backend.expects(:start).yields(@conn)

    @client = Slurm::Restd.new(backend)
  end

  def test_success_get_invocation
    @conn.expects(:run).with do |value|
      value.include?("GET /get/path HTTP/1.1") &&
        value.include?("My-Header: my-header-value")
    end.returns(File.read("test/fixtures/200_jobs_status.txt"))

    response = @client.get("/get/path", "my-header" => "my-header-value")

    assert 200, response.code
    assert "application/json", response["Content-Type"]
    assert "21.08.8-2", JSON.parse(response.body).dig("meta", "Slurm", "release")
  end

  def test_success_post_invocation
    @conn.expects(:run).with do |value|
      value.include?("POST /slurm/v0.0.37/job/submit HTTP/1.1") &&
        value.include?("Content-Type: application/json") &&
        value.include?("data-payload")
    end.returns(File.read("test/fixtures/200_job_created_response.txt"))

    response = @client.post("/slurm/v0.0.37/job/submit", "data-payload", "Content-Type" => "application/json")

    assert 200, response.code
    assert "application/json", response["Content-Type"]
    assert 2_447_759, JSON.parse(response.body)["job_id"]
  end

  def test_success_delete_invocation
    @conn.expects(:run).with do |value|
      value.include?("DELETE /slurm/v0.0.37/job/1234 HTTP/1.1")
    end.returns(File.read("test/fixtures/204.txt"))

    response = @client.delete("/slurm/v0.0.37/job/1234")

    assert 204, response.code
  end

  def test_many_requests_in_one_connection
    @conn.expects(:run).with do |value|
      value.include?("GET /get/path1 HTTP/1.1")
    end.returns(File.read("test/fixtures/200_jobs_status.txt"))

    @conn.expects(:run).with do |value|
      value.include?("GET /get/path2 HTTP/1.1")
    end.returns(File.read("test/fixtures/204.txt"))

    @client.start do |conn|
      assert 200, conn.get("/get/path1").code
      assert 204, conn.get("/get/path2").code
    end
  end

  def test_wrong_credentials
    @conn.expects(:run).raises(Slurm::Backends::AuthenticationError, "wrong credentials")
    response = @client.get("/get/path")

    assert 401, response.code
  end

  def test_slurmrestd_error
    @conn.expects(:run).raises(Slurm::Backends::ExecutionError, "return code != 0")
    response = @client.get("/get/path")

    assert 500, response.code
  end
end
