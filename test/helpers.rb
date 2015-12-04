require 'simplecov'
SimpleCov.start

require 'minitest/reporters'
require 'minitest/autorun'
# require_relative '../lib/jossh'

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)
