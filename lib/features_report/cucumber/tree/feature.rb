
class Cucumber::Tree::Feature
  def title
    header.split("\n").first.strip.gsub(/^Feature: /, "")
  end
end
