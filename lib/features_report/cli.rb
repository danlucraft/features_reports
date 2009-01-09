
module FeaturesReport
  class CLI
    def self.execute
      reader = Reader.new(ARGV)
      Generator.generate(reader)
    end
  end
end
