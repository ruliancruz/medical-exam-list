require 'sinatra'
require 'rack/handler/puma'
require './app/services/exam_service'

get '/tests' do
  content_type :json
  ExamService.all_as_json
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run Sinatra::Application, Port: 3000, Host: '0.0.0.0'
end
