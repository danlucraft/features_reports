
module FeaturesReport
  class CLI
    def self.execute
      opts = Trollop.options do 
        opt :logo, "Corporate logo for the front page", :type => :string
      end

      reader = Reader.new(ARGV)
      generator = Generator.new(reader, opts)
      generator.generate
    end
  end
end
