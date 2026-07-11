require 'net/http'
require 'uri'
require 'json'
 
CATALOG_PATH = File.join(__dir__, "model_catalog")
 
models = File.readlines(CATALOG_PATH).map(&:strip).reject { |l| l.empty? || l.start_with?("#") }
 
models.each_with_index do |model, i|
  puts "#{i + 1}. #{model}"
end
 
print "Select a model number: "
choice = gets.strip.to_i
model = models[choice - 1]
 
uri = URI.parse("http://localhost:1234/api/v1/models")
response = Net::HTTP.get_response(uri)
data = JSON.parse(response.body)["models"]
info = data.find { |m| m["key"] == model }
max_context = info["max_context_length"]
 
puts "Loading #{model} with context length #{max_context}..."
system("lms", "load", model, "--context-length", max_context.to_s)
