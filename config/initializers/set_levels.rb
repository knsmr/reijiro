module Eijiro
  level_file = File.join(Rails.root, %w(db level.yml))
  if File.exist?(level_file)
    LEVEL = YAML::load(File.open(level_file))
  end
end
