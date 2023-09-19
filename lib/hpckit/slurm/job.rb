# frozen_string_literal: true

class HPCKit::Slurm::Job
  attr_reader :id, :script_payload

  def initialize(script_payload, submit_json_response)
    @script_payload = script_payload
    @id = submit_json_response["job_id"]
  end

  def array_job?
    false
  end
end
