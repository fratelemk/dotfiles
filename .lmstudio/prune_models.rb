require 'fileutils'
require 'set'

MODELS_DIR = File.expand_path("~/.lmstudio/models")

keep = Set.new
File.foreach("model_catalog") do |line|
  stripped = line.strip
  next if stripped.empty? || stripped.start_with?("#")
  keep << stripped
end

Dir.glob(File.join(MODELS_DIR, "*", "*")).each do |path|
  next unless Dir.exist?(path)

  key = path.delete_prefix("#{MODELS_DIR}/")
  next if keep.include?(key)

  puts "Removing: #{key}"
  puts "Path: #{path}"
  FileUtils.rm_rf(path)
  puts "-" * 40
end
