require 'simplecov'

unless ENV['NOCOV']
  SimpleCov.start do
    enable_coverage :branch
    primary_coverage :branch
  end
end

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

ENV['TTY'] = 'on'

system 'mkdir tmp' unless Dir.exist? 'tmp'

include Colsole
