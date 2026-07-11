require 'net/http'
require 'uri'
require 'json'

CATALOG_PATH = File.join(__dir__, "model_catalog")

download_uri = URI.parse("http://localhost:1234/api/v1/models/download")
http = Net::HTTP.new(download_uri.host, download_uri.port)

def to_gb(bytes)
  (bytes.to_f / (1024**3)).round(2)
end

def poll_progress(http, job_id)
  status_uri = URI.parse("http://localhost:1234/api/v1/models/download/status/#{job_id}")

  loop do
    response = Net::HTTP.get_response(status_uri)
    data = JSON.parse(response.body)

    case data["status"]
    when "downloading"
      total = data["total_size_bytes"].to_f
      downloaded = data["downloaded_bytes"].to_f
      pct = total > 0 ? (downloaded / total * 100).round(1) : 0
      print "\r  #{pct}% (#{to_gb(downloaded)} GB / #{to_gb(total)} GB)"
      $stdout.flush
      sleep 2
    when "completed"
      puts "\r  Done."
      break
    when "failed"
      puts "\r  Failed: #{data['error'] || data}"
      break
    else
      puts "\r  Status: #{data['status']}"
      sleep 2
    end
  end
end

begin
  File.foreach(CATALOG_PATH) do |line|
    stripped = line.strip
    next if stripped.empty? || stripped.start_with?("#")

    request = Net::HTTP::Post.new(download_uri)
    request["Content-Type"] = "application/json"
    request.body = { model: stripped }.to_json

    response = http.request(request)
    body = JSON.parse(response.body)

    puts "Model: #{stripped}"

    if body["status"] == "already_downloaded"
      puts "  Downloaded"
    elsif body["job_id"]
      poll_progress(http, body["job_id"])
    else
      puts "  Pending: #{body}"
    end

    puts "-" * 40
  end
rescue Interrupt
  puts "\nCancelled."
  exit 130
end
