# frozen_string_literal: true

require "json"

class HPCKit::Slurm::Client
  SLURM_RESTD_VERSION = "v0.0.37"

  def initialize(backend)
    @client = HPCKit::Slurm::Restd.new(backend)
  end

  def submit(script_payload)
    script = HPCKit::Slurm::Script.new(script_payload)
    res = @client.post("/slurm/#{SLURM_RESTD_VERSION}/job/submit", script.to_json,
                       "Content-Type": "application/json")

    res.value
    HPCKit::Slurm::Job.new(script_payload, JSON.parse(res.body))
  rescue Net::HTTPError => e
    #TODO
    puts e
  end

  def update(job)
  end
end
