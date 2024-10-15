# frozen_string_literal: true

class HPCKit::Slurm::Job
  attr_reader :id

  def initialize(backend, options = {})
    @backend = backend
    @options = options
  end

  def self.create(backend, script:, **)
    start do |client|
      result = client.post script
      if result.ok?
        result_json = JSON.parse(result.body)
        @id = result_json["job_id"]
        @raw = result_json

        # new(backend, script:,
      end
    end
  end

  def submit!
    start do |slurm|
      submit_result = slurm.post script
      if submit_result.ok?
        submit_result_json = JSON.parse(submit_result.body)
        @id = submit_result_json["job_id"]
      end
    end
  end

  def submit
    submit!
    true
  rescue
    false
  end

  def script
    Script.new(options[:script], options)
  end

  private
    def start
      restd.start do |conn|
        slurm = Client.new(conn)

        yield slurm
      end
    end

    def restd
      @client ||= Restd.new(@backend)
    end
end
