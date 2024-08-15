require 'sinatra'
require 'rack/handler/puma'
require './helpers/host_helper'
require './app/services/exam_service'

get '/tests' do
  content_type :json
  ExamService.all_as_json
rescue PG::UndefinedTable
  status :service_unavailable
  {
    error: 'Database table not found, run rake db:import_from_csv to set it up'
  }.to_json
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
  {
    error: 'Database table not found, run rake db:import_from_csv to set it up'
  }.to_json
rescue PG::ConnectionBad
  status :service_unavailable
  { error: 'Database connection failure' }.to_json
end

get '/exams' do
  content_type :html
  HostHelper.insert_host File.read('public/exams/index.html'), request.host
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run Sinatra::Application, Port: 3000, Host: '0.0.0.0'
end
