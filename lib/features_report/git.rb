
module FeaturesReport
  class Git
    def self.git_repo?(filename)
      path = File.expand_path(filename)
      while path and path != ""
        if File.exist?(path + "/.git")
          return path
        end
        path = path.split("/")[0..-2].join("/")
      end
      false
    end

    def initialize(files)
      @repo = Grit::Repo.new(Git.git_repo?(files.first))
      @files = files
    end

    def last_changed(feature)
      @repo.log(feature.file).first.date
    end

    attr_reader :files
  end
end
