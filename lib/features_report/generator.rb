
module FeaturesReport
  class Generator
    def initialize(reader, git, opts)
      @reader = reader
      @opts = opts
      @git = git
      @feature_pages ||= {}
      @features = reader.features.map{|f| Feature.new(f, @git)}
    end

    attr_reader :pdf, :reader, :opts

    def generate
      @pdf = Prawn::Document.new :page_size => "A4", :top_margin => 60

      pdf.header [pdf.bounds.right, pdf.bounds.bottom + 10] do
        pdf.text pdf.page_count-1 unless pdf.page_count == 1
      end

      @original_bottom_left = [pdf.bounds.left, pdf.bounds.bottom - 10]

      generate_front_page
      
      sorted_features.each do |feature| 
        generate_feature(feature)
      end
      
      generate_contents_page
      pdf.render_file("features.pdf")
    end

    FEATURE_TITLE_STYLE = {:size => 24}
    SCENARIO_TITLE_STYLE = {:size => 16}
    STEP_STYLE = {}
    FOOTER_STYLE = {:size => 12}
    DOC_TITLE_STYLE = {:size => 32, :align => :center}

    private

    def generate_front_page
      pdf.move_down(200)

      if opts[:logo]
        pdf.image opts[:logo]
      end

      pdf.text "Features Report", DOC_TITLE_STYLE
      pdf.move_down(10)
      pdf.text Time.now.strftime("%e %B %Y"), :align => :center
      
      start_new_page
    end

    class Feature
      def initialize(feature, git)
        @feature = feature
        @git = git
      end

      def header
        @feature.header
      end

      def last_commit
        @last_commit ||= @git.last_commit(@feature)
      end

      def last_changed
        last_commit.date
      end

      def last_author
        last_commit.author.name
      end

      def scenarios
        @feature.scenarios
      end

      def title
        @feature.title
      end

      def contents_text
        title + "\n" + header.split("\n")[1..-1].join("\n")
      end
    end

    def sorted_features
      return @sorted_features if @sorted_features

      @sorted_features = @features.sort_by do |feature| 
        if @git
          feature.last_changed
        else
          feature.title
        end
      end
      
      @sorted_features = @sorted_features.reverse if @git

      @sorted_features
    end

    def generate_contents_page
      clear_footer
      pdf.text "Contents", :size => 20, :align => :center

      data = []
      widths, headers = nil, nil

      sorted_features.each_with_index do |feature, index|
        if @git
          data << [index + 1, feature.contents_text, feature.last_changed.strftime("%e %b"), feature.last_author.split.map{|word| word[0..0].upcase}.join, @feature_pages[feature]] 
          widths = {0 => 30, 1 => 340, 2 => 70, 3 => 40, 4 => 40}
          headers = ["", "Title", "Last Changed", "By", "Page"]
        else
          data << [index + 1, feature.contents_text, @feature_pages[feature]] 
          widths = {0 => 30, 1 => 470, 2 => 30}
          headers = ["", "", ""]
        end
      end

      pdf.move_down 35
      pdf.table data, :border_width => 0, :widths => widths, :headers => headers
    end

    def clear_footer
      pdf.footer(pdf.bounds.bottom_left) {}
    end

    def generate_feature(feature)
      pdf.text "Feature: " + feature.title, FEATURE_TITLE_STYLE
      pdf.text feature.header.split("\n")[1..-1].join("\n")

      pdf.footer @original_bottom_left do 
        pdf.text feature.title, FOOTER_STYLE
      end

      pdf.move_down 20
      @feature_pages[feature] = pdf.page_count-1
      
      feature.scenarios.each do |scenario|
        pdf.text scenario.name, SCENARIO_TITLE_STYLE
        pdf.move_down 4
        scenario.steps.each do |step|
          next if step.is_a?(Cucumber::Tree::RowStep) or step.is_a?(Cucumber::Tree::RowStepOutline) # TODO: deal with these
          pdf.text step.keyword + " " + step.name, STEP_STYLE
        end
        pdf.move_down 10
      end
      
      start_new_page
    end

    def start_new_page
      pdf.start_new_page(:bottom_margin => 60)
    end

  end
end
