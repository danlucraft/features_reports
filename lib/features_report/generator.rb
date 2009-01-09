
module FeaturesReport
  class Generator
    def self.generate(reader)
      Prawn::Document.generate("features.pdf") do
        reader.features.each do |feature| 
          text feature.title, :size => 32

          feature.scenarios.each do |scenario|
            text scenario.name, :size => 24

            scenario.steps.each do |step|
              text step.name
            end
          end
        end
      end
    end
  end
end
