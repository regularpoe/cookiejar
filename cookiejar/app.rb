# frozen_string_literal: true

require 'json'
require 'sinatra/base'

class App < Sinatra::Base
  before do
    content_type :json
    logger.info "Headers: #{request.env.select { |k, v| k.start_with?('HTTP_') }}"
  end

  get '/' do
    { status: 200, result: 'Hello from cookiejar' }.to_json
  end

  get '/slow' do
    sleep(rand(1..5))

    { status: 200, result: 'Hello from GET /slow' }.to_json
  end

  get '/random_error' do
    if rand < 0.2
      status 500
      "Oops! Something went wrong!"
    else
      { status: 200, result: 'Hello from GET /random_error' }.to_json
    end
  end

  get '/stream' do
    content_type 'text/plain'

    text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at odio eu lacus fringilla vestibulum. Nulla nec augue sapien. Quisque venenatis nibh vel quam laoreet tincidunt. Sed sagittis rutrum urna, sit amet pretium est gravida vel. In ullamcorper elit elit, eget malesuada quam hendrerit nec. Donec venenatis tellus nec mauris semper vehicula. Sed bibendum tellus a mauris vehicula consectetur. Praesent vel tellus vel odio semper aliquam. Vestibulum auctor enim ac elit sagittis, ac euismod odio consequat. Nulla faucibus quam eget risus efficitur luctus. Sed vel justo quis sapien vestibulum malesuada. Ut bibendum ante ac lacinia pellentesque. Donec lobortis enim nunc, id consequat est vestibulum nec.'

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

    response.to_json
  end

end
