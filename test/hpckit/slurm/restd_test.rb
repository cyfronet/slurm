# frozen_string_literal: true

require "test_helper"
require "json"
require "hpckit/slurm/backends/mock"

class HPCKit::Slurm::RestdTest < Minitest::Test
  def setup
    @backend = HPCKit::Slurm::Backends::Mock.new
    @client = HPCKit::Slurm::Restd.new(@backend)
  end

  def test_success_get_invocation
    @backend.expects_get("/get/path",
                      File.read("test/fixtures/200_jobs_status.txt"),
                      headers: { "My-Header" => "my-header-value" })

    response = @client.get("/get/path", "my-header" => "my-header-value")

    assert 200, response.code
    assert "application/json", response["Content-Type"]
    assert "21.08.8-2", JSON.parse(response.body).dig("meta", "Slurm", "release")
  end

  def test_success_post_invocation
    @backend.expects_post("/post/path", File.read("test/fixtures/200_job_created_response.txt")) do |value|
      value.include?("data-payload")
    end

    response = @client.post("/post/path", "data-payload", "Content-Type" => "application/json")

    assert 200, response.code
    assert "application/json", response["Content-Type"]
    assert 2_447_759, JSON.parse(response.body)["job_id"]
  end

  def test_success_delete_invocation
    @backend.expects_delete("/delete/path", File.read("test/fixtures/204.txt"))

    response = @client.delete("/delete/path")

    assert 204, response.code
  end

  def test_many_requests_in_one_connection
    @backend.expects_get("/get/path1", File.read("test/fixtures/200_jobs_status.txt"))
    @backend.expects_get("/get/path2", File.read("test/fixtures/204.txt"))

    @client.start do |conn|
      assert 200, conn.get("/get/path1").code
      assert 204, conn.get("/get/path2").code
    end
  end

  def test_wrong_credentials
    @backend.expects_raise(HPCKit::Slurm::Backends::AuthenticationError, "wrong credentials")

    response = @client.get("/get/path")

    assert 401, response.code
  end

  def test_slurmrestd_error
    @backend.expects_raise(HPCKit::Slurm::Backends::ExecutionError, "return code != 0")

    response = @client.get("/get/path")

    assert 500, response.code
  end
end
