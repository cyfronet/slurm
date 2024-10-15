# frozen_string_literal: true

require "json"

class HPCKit::Slurm::Client
  SLURM_RESTD_VERSION = "v0.0.39"

  def initialize(connection)
    @connection = connection
  end

  def diag
    @connection.get("/slurm/#{SLURM_RESTD_VERSION}/diag")
  end

  def ping
    @connection.get("/slurm/#{SLURM_RESTD_VERSION}/diag")
  end

  def jobs
    @connection.get("/slurm/#{SLURM_RESTD_VERSION}/jobs")
  end

  def job(job_id)
    @connection.get("/slurm/#{SLURM_RESTD_VERSION}/job/#{job_id}")
  end

  def update(job_id, job_properties)
    @connection.post("/slurm/#{SLURM_RESTD_VERSION}/job/#{job_id}", job_properties.to_json,
                 "Content-Type": "application/json")
  end

  # TODO - handle signal
  def cancel(job_id, signal)
    @connection.delete("/slurm/#{SLURM_RESTD_VERSION}/job/#{job_id}")
  end

  def submit(script)
    @connection.post("/slurm/#{SLURM_RESTD_VERSION}/job/submit", script.to_json,
                 "Content-Type": "application/json")
  end

  def nodes(update_time = nil)
    @connection.get("/slurm/#{SLURM_RESTD_VERSION}/nodes")
  end

  def node(node_name)
    @connection.get("/slurm/#{SLURM_RESTD_VERSION}/node/#{node_name}")
  end

  def partitions(update_time = nil)
    @connection.get("/slurm/#{SLURM_RESTD_VERSION}/partitions")
  end

  def partition(partition_name, update_time = nil)
    @connection.get("/slurm/#{SLURM_RESTD_VERSION}/partition/#{partition_name}")
  end

  def reservations(update_time = nil)
    @connection.get("/slurm/#{SLURM_RESTD_VERSION}/reservations")
  end

  def reservation(reservation_name, update_time = nil)
    @connection.get("/slurm/#{SLURM_RESTD_VERSION}/reservation/#{reservation_name}")
  end
end
