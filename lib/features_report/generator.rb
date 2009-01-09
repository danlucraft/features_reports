
module FeaturesReport
  class Generator
    def initialize(reader, opts)
      @reader = reader
      @opts = opts
      @feature_pages ||= {}
    end

    attr_reader :pdf, :reader, :opts

    def generate
      Prawn::Document.generate("features.pdf") do |prawn_pdf|
        @pdf = prawn_pdf
        generate_front_page

        reader.features.each do |feature| 
          generate_feature(feature)
        end

        generate_contents_page
      end
    end

    FEATURE_TITLE_STYLE = {
      :size => 24
    }

    SCENARIO_TITLE_STYLE = {
      :size => 16
    }

    STEP_STYLE = {
      :size => 12
    }

    private

    def generate_front_page
      pdf.move_down(200)
      if opts[:logo]
        pdf.image opts[:logo]
      end
      pdf.text "Features Report", :size => 32, :align => :center
      
      pdf.start_new_page
    end

    def generate_contents_page
      pdf.text "Contents", :size => 20, :align => :center

      data = []
      reader.features.each_with_index do |feature, i|
        data << [i+1, feature.title, @feature_pages[feature]]
      end

      pdf.move_down 35
      pdf.table data, :border_width => 0, :widths => {0 => 30, 1 => 450, 2 => 30}
      
      pdf.start_new_page
    end

    def generate_feature(feature)
      pdf.text feature.title, FEATURE_TITLE_STYLE
      @feature_pages[feature] = pdf.page_count-1
      
      feature.scenarios.each do |scenario|
        pdf.text scenario.name, SCENARIO_TITLE_STYLE
        scenario.steps.each do |step|
          next if step.is_a?(Cucumber::Tree::RowStep) # TODO: deal with these

          pdf.text step.name, STEP_STYLE
        end
      end
      
      pdf.text pdf.page_count-1, :at => pdf.bounds.bottom_right
      pdf.start_new_page
    end

  end
end
