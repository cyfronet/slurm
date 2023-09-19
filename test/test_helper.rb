# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "hpckit"

require "debug"
require "minitest/autorun"
require "mocha/minitest"

class Minitest::Test
  def fixture(name)
    File.read(File.join("test/fixtures", name))
  end
end
