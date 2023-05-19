# frozen_string_literal: true

require "test_helper"
require "hpckit/slurm/sbatch_parser"

class HPCKit::Slurm::TestSbatchParser < Minitest::Test
  def test_minutes_to_seconds
    assert_equal 123 * 60, HPCKit::Slurm::SbatchParser.parse_time("123")
  end

  def test_minutest_seconds_to_seconds
    assert_equal 62, HPCKit::Slurm::SbatchParser.parse_time("1:2")
  end

  def test_hours_minutest_seconds_to_seconds
    assert_equal 360 + 2 * 60 + 3, HPCKit::Slurm::SbatchParser.parse_time("1:2:3")
  end

  def test_day_hours_to_seconds
    assert_equal (24 + 2) * 360, HPCKit::Slurm::SbatchParser.parse_time("1-2")
  end

  def test_day_hours_minutes_to_seconds
    assert_equal (24 + 2) * 360 + 3 * 60, HPCKit::Slurm::SbatchParser.parse_time("1-2:3")
  end

  def test_day_hours_minutes_seconds_to_seconds
    assert_equal (24 + 2) * 360 + 3 * 60 + 4, HPCKit::Slurm::SbatchParser.parse_time("1-2:3:4")
  end
end
