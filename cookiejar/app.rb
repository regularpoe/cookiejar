# frozen_string_literal: true

require 'json'
require 'logger'
require 'sinatra/base'

class MultiIO
  def initialize(*targets)
    @targets = targets
  end

  def write(*args)
    @targets.each { |t| t.write(*args) }
  end

  def close
    @targets.each(&:close)
  end

  def flush
    @targets.each(&:flush)
  end
end

class App < Sinatra::Base
  configure do
    log_file = File.new("#{settings.root}/app.log", 'a+')
    log_file.sync = true

    multi_logger = Logger.new(MultiIO.new(STDOUT, log_file))

    multi_logger.level = Logger::INFO

    use Rack::CommonLogger, multi_logger

    set :logger, multi_logger
  end

  before do
    content_type :json
    logger.info "Headers: #{request.env.select { |k, v| k.start_with?('HTTP_') }}"
    logger.info "Request: #{request.request_method} #{request.path_info} with params #{params}"
  end

  after do
    logger.info "Response: #{response.status}"
  end

  get '/' do
    result = { status: 200, result: 'Hello from cookiejar' }.to_json
    logger.info "GET / response: #{result}"
    result
  end

  get '/slow' do
    delay = rand(1..5)
    logger.info "Sleeping for #{delay} seconds"
    sleep(delay)

    result = { status: 200, result: 'Hello from GET /slow' }.to_json
    logger.info "GET /slow response: #{result}"
    result
  end

  get '/random_error' do
    if rand < 0.2
      logger.error "Random error occurred!"
      status 500
      "Oops! Something went wrong!"
    else
      result = { status: 200, result: 'Hello from GET /random_error' }.to_json
      logger.info "GET /random_error response: #{result}"
      result
    end
  end

  get '/stream' do
    content_type 'text/plain'
    logger.info "Streaming text in chunks..."

    text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...'
    chunk_size = 10
    delay = 0.1

    stream do |out|
      text.chars.each_slice(chunk_size) do |chunk|
        sleep delay
        out << chunk.join
      end
    end
  end

  get '/status' do
    current_time = Time.now.strftime('%d/%m/%Y %H:%M')

    response = {
      ruby_version: RUBY_VERSION,
      sinatra_version: Sinatra::VERSION,
      current_time: current_time
    }

    result = response.to_json
    logger.info "GET /status response: #{result}"
    result
  end
end

