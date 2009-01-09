
module FeaturesReport
  class Generator
    def self.generate(reader)
      reader.features.each { |f| puts f.title }
    end
  end
end
