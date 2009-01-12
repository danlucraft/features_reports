
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

    def git_dir
      @repo.path.split("/")[0..-2].join("/")
    end

    def last_commit(feature)
      filename = File.expand_path(feature.file, git_dir).gsub(/^#{Regexp.escape(git_dir)}\//, "")
      commit = @repo.log(@repo.head.name, filename).first
    end

    attr_reader :files
  end
end
