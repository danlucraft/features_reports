
module FeaturesReport
  class Generator
    def self.generate(reader)
      Prawn::Document.generate("features.pdf") do
        text "Contents", :size => 24
        
        reader.features.each_with_index do |feature, i|
          text "#{i+1}. #{feature.title}"
        end

        start_new_page

        reader.features.each do |feature| 
          text feature.title, :size => 24

          feature.scenarios.each do |scenario|
            text scenario.name, :size => 16

            scenario.steps.each do |step|
              text step.name
            end
          end
        end
      end
    end
  end
end
