
module FeaturesReport
  class CLI
    def self.execute
      opts = Trollop.options do 
        version "features_report 0.1 (c) 2008 Daniel Lucraft & Niko Felger"
        banner <<-EOS
features_report turns Cucumber features into a pretty PDF report.

Usage:
       features_report [options] <filenames>+

where [options] are:
EOS

        opt :logo, "Path to image for the front page", :type => :string
      end
      Trollop.die "no features files given" if ARGV.empty?
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
