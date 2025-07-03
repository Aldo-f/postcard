require 'rack'
require 'net/http'
require 'uri'
require 'json'
require 'logger'

# Configuration
TARGET_HOST = ENV['TARGET_HOST'] || 'https://a.postcard.page'
PROXY_SECRET = ENV['PROXY_SECRET']
if PROXY_SECRET.nil? || PROXY_SECRET.empty?
  raise "PROXY_SECRET environment variable is required but not set"
end

logger = Logger.new($stdout)

app = Proc.new do |env|
  request = Rack::Request.new(env)

  # Logging
  logger.info("Proxy request received: #{request.request_method} #{request.path}")

  # Construct target URI
  uri = URI.parse(TARGET_HOST)
  uri.path = request.path
  uri.query = request.query_string unless request.query_string.empty?

  # Forward the request
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == 'https'
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  # Create the appropriate request object
  proxy_request = case request.request_method
  when 'GET'    then Net::HTTP::Get.new(uri)
  when 'POST'   then Net::HTTP::Post.new(uri)
  when 'PUT'    then Net::HTTP::Put.new(uri)
  when 'DELETE' then Net::HTTP::Delete.new(uri)
  when 'PATCH'  then Net::HTTP::Patch.new(uri)
  when 'HEAD'   then Net::HTTP::Head.new(uri)
  when 'OPTIONS'then Net::HTTP::Options.new(uri)
  else
    logger.warn("Unsupported method: #{request.request_method}")
    return [405, {'Content-Type' => 'text/plain'}, ["Method not supported"]]
  end

  # Forward request headers
  request.env.each do |key, value|
    if key.start_with?('HTTP_') && key != 'HTTP_HOST'
      header_key = key.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-')
      proxy_request[header_key] = value
    end
  end

  # Preserve content type and content length
  if request.content_type
    proxy_request['Content-Type'] = request.content_type
  end

  # Add custom identification headers
  proxy_request['X-Proxy-Server'] = 'render-proxy'
  proxy_request['x-proxy-secret'] = PROXY_SECRET

  # Preserve original client IP
  if request.env['HTTP_X_FORWARDED_FOR']
    proxy_request['X-Forwarded-For'] = request.env['HTTP_X_FORWARDED_FOR']
  elsif request.env['REMOTE_ADDR']
    proxy_request['X-Forwarded-For'] = request.env['REMOTE_ADDR']
  end

  # Forward original host
  if request.env['HTTP_HOST']
    proxy_request['X-Forwarded-Host'] = request.env['HTTP_HOST']
  end

  # Forward request body for appropriate methods
  if ['POST', 'PUT', 'PATCH'].include?(request.request_method)
    request_body = request.body.read
    proxy_request.body = request_body
    request.body.rewind
  end

  begin
    # Get the response
    proxy_response = http.request(proxy_request)

    # Extract response headers
    headers = {}
    proxy_response.each_header do |key, value|
      # Skip certain headers that Rack will set
      next if ['transfer-encoding', 'connection'].include?(key.downcase)
      headers[key] = value
    end

    # Ensure response body is never nil
    response_body = proxy_response.body || ""

    # Return the proxied response
    [
      proxy_response.code.to_i,
      headers,
      [response_body]
    ]
  rescue => e
    logger.error("Proxy error: #{e.message}")
    [
      502,
      {'Content-Type' => 'application/json'},
      [JSON.generate({error: "Proxy Error", message: e.message})]
    ]
  end
end

# Middleware for basic request logging
class RequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    start_time = Time.now
    status, headers, body = @app.call(env)
    end_time = Time.now
    duration = (end_time - start_time) * 1000 # convert to milliseconds

    request = Rack::Request.new(env)
    puts "[#{Time.now}] #{request.request_method} #{request.path} - #{status} (#{duration.round(2)}ms)"

    [status, headers, body]
  end
end

# Use the middleware
use RequestLogger

# Run the app
run app
