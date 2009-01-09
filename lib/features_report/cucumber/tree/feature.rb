
class Cucumber::Tree::Feature
  def title
    header.split("\n").first.squeeze.gsub(/^Feature: /, "")
  end
end
