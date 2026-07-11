require 'json'
require 'fileutils'

CONFIG_PATH = File.expand_path("~/.config/opencode/opencode.json")
CATALOG_PATH = File.join(__dir__, "model_catalog")

FileUtils.mkdir_p(File.dirname(CONFIG_PATH))

config = File.exist?(CONFIG_PATH) ? JSON.parse(File.read(CONFIG_PATH)) : {}

config["$schema"] ||= "https://opencode.ai/config.json"
config["provider"] ||= {}
config["provider"]["lmstudio"] ||= {
  "npm" => "@ai-sdk/openai-compatible",
  "name" => "LM Studio (local)",
  "options" => { "baseURL" => "http://127.0.0.1:1234/v1" },
  "models" => {}
}
config["provider"]["lmstudio"]["models"] ||= {}

models = config["provider"]["lmstudio"]["models"]
added = []

File.foreach(CATALOG_PATH) do |line|
  stripped = line.strip
  next if stripped.empty? || stripped.start_with?("#")
  next if models.key?(stripped)

  display_name = stripped.split("/").last
  models[stripped] = { "name" => display_name }
  added << stripped
end

File.write(CONFIG_PATH, JSON.pretty_generate(config) + "\n")

if added.empty?
  puts "No new models added. All catalog models are already in #{CONFIG_PATH}."
else
  puts "Added #{added.size} model(s) to #{CONFIG_PATH}:"
  added.each { |m| puts "  - #{m}" }
end
