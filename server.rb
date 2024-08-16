require 'sinatra'
require 'rack/handler/puma'
require './helpers/host_helper'
require './app/services/exam_service'
require './app/services/csv_importer'

get '/' do
  content_type :html
  HostHelper.insert_host File.read('public/index.html'), request.host
end

get '/tests' do
  content_type :json
  ExamService.all_as_json
rescue PG::UndefinedTable
  status :service_unavailable
  { error: 'Database table not found, there are migrations pending' }.to_json
rescue PG::ConnectionBad
  status :service_unavailable
  { error: 'Database connection failure' }.to_json
end

get '/tests/:token' do
  content_type :json
  response = ExamService.find_by_token params[:token]

  status :not_found if response.include? 'error'
  response
rescue PG::UndefinedTable
  status :service_unavailable
  { error: 'Database table not found, there are migrations pending' }.to_json
rescue PG::ConnectionBad
  status :service_unavailable
  { error: 'Database connection failure' }.to_json
end

post '/import' do
  unless CSVImporter.import_to_database(request.body.read)
    content_type :json
    status :bad_request
    return { error: 'The CSV file is not in the correct format' }.to_json
  end

  content_type :json
  status :created
  return { message: 'CSV imported to database' }.to_json
rescue PG::UndefinedTable
  status :service_unavailable
  { error: 'Database table not found, there are migrations pending' }.to_json
rescue PG::ConnectionBad
  status :service_unavailable
  { error: 'Database connection failure' }.to_json
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run Sinatra::Application, Port: 3000, Host: '0.0.0.0'
end
