# frozen_string_literal: true

require 'json'
require 'sinatra/base'

class App < Sinatra::Base
  before do
    content_type :json
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
