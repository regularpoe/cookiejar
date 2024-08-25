# frozen_string_literal: true

require 'json'
require 'sinatra/base'

class App < Sinatra::Base
  before do
    content_type :json
  end

  get '/strings/lowercase/:string' do
    { status: 200, result: params['string'].downcase }.to_json
  end

  get '/strings/upercase/:string' do
    { status: 200, result: params['string'].upcase }.to_json
  end

  get '/strings/length/:string' do
    { status: 200, result: params['string'].length }.to_json
  end

  get '/strings/capitalize/:string' do
    { status: 200, result: params['string'].capitalize }.to_json
  end

  get '/strings/chars/:string' do
    { status: 200, result: params['string'].chars }.to_json
  end

  get '/strings/occurrences/:string/:char' do
    { status: 200, result: params['string'].count(params['char']) }.to_json
  end

end
