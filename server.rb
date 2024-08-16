require 'sinatra'
require 'securerandom'
require 'sidekiq/web'
require 'rack-protection'
require 'rack/handler/puma'
require './helpers/host_helper'
require './app/services/exam_service'
require './app/services/csv_importer'
require './app/workers/csv_import_worker'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis:6379/0' }
end

use Rack::Session::Cookie,
    key: 'rack.session',
    secret: SecureRandom.hex(64),
    same_site: true

Sidekiq::Web.use Rack::Auth::Basic, 'Protected Area' do |username, password|
  username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
end

class SidekiqApp < Sinatra::Base
  use Sidekiq::Web
end

use Rack::Builder do
  map '/sidekiq' do
    run Sidekiq::Web
  end
end

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
  if ENV['RACK_ENV'] == 'test'
    CSVImporter.import_to_database request.body.read
  else
    CSVImportWorker.perform_async request.body.read
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
