# frozen_string_literal: true

require "optparse"
require "hpckit/slurm/option_parser"
require "json"

class HPCKit::Slurm::Script
  SBATCH_LINE = /\A\s*#SBATCH .+/
  SBATCH_KEY_VALUE = /\A\s*#SBATCH (?<key>-{1,2}[a-zA-z-]*)(?<connector>=|\s*)(?<value>.*)/

  def initialize(raw_script)
    @raw = raw_script
  end

  def script
    @raw.lines.reject { |l| SBATCH_LINE.match?(l) }.join("")
  end

  def options
    args = @raw.lines
                .select { |l| SBATCH_LINE.match?(l) }
                .map do |l|
                  m = SBATCH_KEY_VALUE.match(l)
                  if m[:key].match(/\A-[a-zA-Z]\z/)
                    "#{m[:key]}#{m[:value]}"
                  else
                    "#{m[:key]}=#{m[:value]}"
                  end
                end

    parse(args)
  end

  def to_h
    { job: { environment: { "HPCKIT" => true} }.merge(options), script: script }
  end

  def to_json
    JSON.generate to_h
  end

  private
    def parse(args)
      HPCKit::Slurm::OptionParser.new(args).options
    end
end
