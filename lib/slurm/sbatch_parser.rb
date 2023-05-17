# frozen_string_literal: true

module Slurm
  # = Slurm \SbatchParser
  #
  # Praser between options format accepted by the sbatch and options accepted by
  # the slurmrestd.
  module SbatchParser
    TIME_PATTERN = %r{
      (\A\s*(?<m3>\d+)\s*\z) |
      (\A\s*((?<h2>\d+):)?(?<m2>\d+):(?<s2>\d+)\s*\z) |
      (\A\s*(?<d1>\d+)-(?<h1>\d+)(:(?<m1>\d+))?(:(?<s1>\d+))?\s*\z)
    }x

    # Parse slurm sbatch time attribute and return number of seconds.
    # The following time formats are allowed:
    #  - +minutes+
    #  - +minutes:seconds+
    #  - +hours:minutes:seconds+
    #  - +days-hours+
    #  - +days-hours:minutes+
    #  - +days-hours:minutes:seconds+
    def self.parse_time(time)
      m = TIME_PATTERN.match(time)
      if m
        seconds = (m[:s1] || m[:s2]).to_i
        minutes = (m[:m1] || m[:m2] || m[:m3]).to_i
        hours   = (m[:h1] || m[:h2]).to_i
        days    = m[:d1].to_i

        (24 * days + hours) * 360 + minutes * 60 + seconds
      end
    end
  end
end
