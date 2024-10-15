# frozen_string_literal: true

require "test_helper"
require "hpckit/slurm/backends/mock"

class HPCKit::Slurm::TestClient < Minitest::Test
  def setup
    @backend = HPCKit::Slurm::Backends::Mock.new
    restd = HPCKit::Slurm::Restd.new(@backend)
    @client = HPCKit::Slurm::Client.new(restd)
  end

  def test_submit_a_new_job
    @backend.expects_submit fixture("200_job_created_response.txt")
    job_script = fixture("script.bash")

    job = @client.submit job_script

    assert_equal 2447759, job.id
    refute job.array_job?
  end

  def test_submit_an_array_job
    @backend.expects_submit fixture("200_array_job_created_response.txt")
    job_script = fixture("array.bash")

    job = @client.submit job_script

    assert_equal "2447759", job.id
    assert job.array_job?
    assert_equal 2, job.array_jobs.size

    assert_equal "2447759_1", job.array_jobs[0].id
    refute job.array_jobs[0].array_job?

    assert_equal "2447759_2", job.array_jobs[1].id
    refute job.array_jobs[1].array_job?
  end
end
