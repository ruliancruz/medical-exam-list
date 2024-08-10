require 'sinatra'
require 'rack/handler/puma'
require './app/services/csv_service'

CSV_PATH = './storage/data.csv'.freeze

get '/tests' do
  content_type :json
  CsvService.read_csv(CSV_PATH).to_json
end

Rack::Handler::Puma.run Sinatra::Application, Port: 3000, Host: '0.0.0.0'
