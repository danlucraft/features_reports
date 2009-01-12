
require File.dirname(__FILE__) + '/spec_helper.rb'

include FeaturesReport

describe FeaturesReport::Git do
  describe ".git_repo?" do
    it "should be true if in a git repo" do
      Git.git_repo?("spec/").should_not be_nil
    end

    it "should be false if not in a git repo" do
      # linux specific
      Git.git_repo?("/usr/local").should be_false
    end
  end
end

