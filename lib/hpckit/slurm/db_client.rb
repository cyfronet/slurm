# frozen_string_literal: true

require "json"

class HPCKit::Slurm::DbClient
  SLURM_RESTD_VERSION = "v0.0.39"

  def initialize(restd)
    @client = restd
  end

  def job(job_id)
    @client.get("/slurmdb/#{SLURM_RESTD_VERSION}/job/#{job_id}")
  end

  def config
    @client.get("/slurmdb/#{SLURM_RESTD_VERSION}/config")
  end

  def tres
    @client.get("/slurmdb/#{SLURM_RESTD_VERSION}/tres")
  end

  #...
end
