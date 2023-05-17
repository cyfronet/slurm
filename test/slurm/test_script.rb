# frozen_string_literal: true

require "test_helper"

class Slurm::TestScript < Minitest::Test
  RAW_SCRIPT = <<~SCRIPT
    #!/bin/bash
    #SBATCH --time=01:02:03
    #SBATCH -p plgrid-now
    #SBATCH -A plggrant-cpu
    #SBATCH --mail-user=foo@bar.local

    echo hello

    exit 0
  SCRIPT

  def test_extract_script
    script = <<~SCRIPT
      #!/bin/bash

      echo hello

      exit 0
    SCRIPT

    assert_equal script, Slurm::Script.new(RAW_SCRIPT).script
  end

  def test_extract_options
    options = { time_limit: 360 + 2 * 60 + 3,
                partition: "plgrid-now",
                account: "plggrant-cpu",
                mail_user: "foo@bar.local" }

    assert_equal options, Slurm::Script.new(RAW_SCRIPT).options
  end
end
