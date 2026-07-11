require 'net/http'
require 'uri'
require 'json'
 
CATALOG_PATH = File.join(__dir__, "model_catalog")
 
uri = URI.parse("http://localhost:1234/api/v1/models/download")
 
http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Post.new(uri)
 
File.foreach(CATALOG_PATH) do |line|
  stripped = line.strip
  next if stripped.empty? || stripped.start_with?("#")
 
  request = Net::HTTP::Post.new(uri)
  request["Content-Type"] = "application/json"
 
  request.body = {
    model: stripped
  }.to_json
 
  response = http.request(request)
 
  puts "Model: #{stripped}"
  puts "Body: #{response.body}"
  puts "-" * 40
end
