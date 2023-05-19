# frozen_string_literal: true

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect "hpckit" => "HPCKit"
loader.setup

module HPCKit
  class Error < StandardError; end
end
