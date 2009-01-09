
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module FeaturesReport
  VERSION = '0.1.0'
end

require 'rubygems'
require 'prawn'
require 'trollop'

begin
  require 'grit'
rescue
end

require 'features_report/reader'
require 'features_report/generator'
require 'features_report/cli'
require 'features_report/git'
FeaturesReport::Reader.load_cucumber
require 'features_report/cucumber/tree/feature'
