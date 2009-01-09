
module FeaturesReport
  class Reader
    attr_reader :files

    def initialize(glob)
      @files = Dir[glob]
    end

    def self.load_cucumber
      require "cucumber"
      require "cucumber/treetop_parser/feature_en"
      Cucumber.load_language("en")
  
      Cucumber::Tree::Feature.class_eval do
        attr_reader :scenarios
      end
    end
    
    def features
      files.map do |file|
        parser.parse_feature(file)
      end
    end

    def parser
      @parser ||= Cucumber::TreetopParser::FeatureParser.new
    end
  end
end
