# frozen_string_literal: true

require "test_helper"

class HPCKit::Slurm::ScriptTest < Minitest::Test
  SBATCH_SCRIPT = <<~SCRIPT
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

    assert_equal script, HPCKit::Slurm::Script.new(SBATCH_SCRIPT).script
  end

  def test_extract_options
    options = {
      time_limit: { set: true, infinite: false, number: 360 + 2 * 60 + 3 },
      partition: "plgrid-now",
      account: "plggrant-cpu",
      mail_user: "foo@bar.local"
    }

    assert_equal options, HPCKit::Slurm::Script.new(SBATCH_SCRIPT).options
  end
end
