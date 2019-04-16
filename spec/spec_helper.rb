require 'simplecov'
SimpleCov.start

require 'rubygems'
require 'bundler'
Bundler.require :default, :development

system 'mkdir tmp' unless Dir.exist? 'tmp'

include Colsole
