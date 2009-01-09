
module FeaturesReport
  class Generator
    def initialize(reader, git, opts)
      @reader = reader
      @opts = opts
      @git = git
      @feature_pages ||= {}
    end

    attr_reader :pdf, :reader, :opts

    def generate
      @pdf = Prawn::Document.new :page_size => "A4", :top_margin => 60

      pdf.header [pdf.bounds.right, pdf.bounds.bottom + 10] do
        pdf.text pdf.page_count-1 unless pdf.page_count == 1
      end

      @original_bottom_left = [pdf.bounds.left, pdf.bounds.bottom - 10]

      generate_front_page
      
      reader.features.each do |feature| 
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

    def generate_contents_page
      clear_footer
      pdf.text "Contents", :size => 20, :align => :center

      data = []
      reader.features.each_with_index do |feature, i|
        if @git
          data << [i+1, feature.title, @git.last_changed(feature).strftime("%e %b"), @feature_pages[feature]]
        else
          data << [i+1, feature.title, "", @feature_pages[feature]]       
        end
      end

      pdf.move_down 35
      pdf.table data, :border_width => 0, :widths => {0 => 30, 1 => 360, 2 => 100, 3 => 30}, :headers => ["", "", "Last Changed", ""]
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
          next if step.is_a?(Cucumber::Tree::RowStep) # TODO: deal with these
          
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
