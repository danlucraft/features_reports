
module FeaturesReport
  class CLI
    def self.execute
      opts = Trollop.options do 
        opt :logo, "Corporate logo for the front page", :type => :string
      end

      reader = Reader.new(ARGV)
      if defined?(Grit) and Git.git_repo?(ARGV.first)
        git = Git.new(ARGV)
      else
        git = nil
      end
      generator = Generator.new(reader, git, opts)
      generator.generate
    end
  end
end
