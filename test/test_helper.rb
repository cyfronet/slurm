# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "slurm"

require "debug"
require "minitest/autorun"
require "mocha/minitest"
