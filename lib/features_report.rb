
$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module FeaturesReport
  VERSION = '0.1.0'
end

require 'rubygems'
require 'features_report/reader'
FeaturesReport::Reader.load_cucumber
require 'features_report/cucumber/tree/feature'
