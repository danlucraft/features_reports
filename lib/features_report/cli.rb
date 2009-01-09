
module FeaturesReport
  class CLI
    def self.execute
      reader = Reader.new(ARGV)
      generator = Generator.new(reader)
      generator.generate
    end
  end
end
