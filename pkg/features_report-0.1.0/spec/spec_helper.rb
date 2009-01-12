
begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'features_report'

FEATURE_FIXTURES_GLOB = "spec/fixtures/features/*.feature" unless defined?(FEATURE_FIXTURES_GLOB)
