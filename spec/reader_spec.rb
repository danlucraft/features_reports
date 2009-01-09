
require File.dirname(__FILE__) + '/spec_helper.rb'

include FeaturesReport

describe FeaturesReport::Reader do
  
  before(:each) do
    @reader = Reader.new(FEATURE_FIXTURES_GLOB)
  end

  it "should load the features" do
    @reader.features.length.should == 2
    
    @reader.features.map {|f| f.title}.sort.should == ["Log in to the site", "Sign up to the site"]
  end

  it "should load the scenarios" do
    login_feature = @reader.features.detect {|f| f.title == "Log in to the site"}
    login_feature.scenarios.length.should == 4
    login_scenario = login_feature.scenarios.last
    login_scenario.name.should == "Log in with bad password and then log in"
  end
end
