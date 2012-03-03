module Eijiro
  level_file = File.join(Rails.root, %w(db level.yml))
  LEVEL = YAML::load(File.open(level_file))
end
