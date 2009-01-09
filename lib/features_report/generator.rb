
module FeaturesReport
  class Generator
    def initialize(reader)
      @reader = reader
    end

    attr_reader :pdf, :reader

    def generate
      Prawn::Document.generate("features.pdf") do |prawn_pdf|
        @pdf = prawn_pdf
        generate_contents_page

        reader.features.each do |feature| 
          generate_feature(feature)
        end
      end
    end

    private

    def generate_contents_page
      pdf.text "Features Report", :size => 32, :align => :center
      pdf.text "Contents", :size => 16
      
      reader.features.each_with_index do |feature, i|
        pdf.text "#{i+1}. #{feature.title}"
      end
      
      pdf.start_new_page
    end

    def generate_feature(feature)
      pdf.text feature.title, :size => 24
      
      feature.scenarios.each do |scenario|
        pdf.text scenario.name, :size => 16
        
        scenario.steps.each do |step|
          next if step.is_a?(Cucumber::Tree::RowStep) # TODO: deal with these

          pdf.text step.name
        end
      end
      
      pdf.text pdf.page_count-1, :at => pdf.bounds.bottom_right
      pdf.start_new_page
    end
  end
end
