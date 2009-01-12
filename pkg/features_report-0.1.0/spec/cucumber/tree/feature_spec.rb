
require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe Cucumber::Tree::Feature do 
  before(:each) do
    reader = Reader.new(["spec/fixtures/features/login.feature"])
    @feature = reader.features.first
  end

  it "should have a title" do
    @feature.title.should == "Log in to the site"
  end
end
