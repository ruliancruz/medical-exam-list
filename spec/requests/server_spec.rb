require 'rack/test'
require './server'
require './app/services/database/database_table_manager'
require './app/services/csv_importer'
require './app/services/exam_service'

RSpec.describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'GET /tests' do
    it 'returns a test list' do
      DatabaseTableManager.drop_all
      DatabaseTableManager.migrate
      CSVImporter.import_to_database File.read './spec/fixtures/data.csv'

      get '/tests'

      expect(last_response).to be_ok
      json = JSON.parse last_response.body
      expect(json.length).to eq 2

      expect(json.first['token']).to eq 'IQCZ17'
      expect(json.first['date']).to eq '2021-08-05'
      expect(json.first['patient']['cpf']).to eq '048.973.170-88'
      expect(json.first['patient']['name']).to eq 'Emilly Batista Neto'
      expect(json.first['patient']['email']).to eq 'gerald.crona@ebert.com'
      expect(json.first['patient']['birthdate']).to eq '2001-03-11'
      expect(json.first['doctor']['crm']).to eq 'B000BJ20J4'
      expect(json.first['doctor']['crm_state']).to eq 'PI'
      expect(json.first['doctor']['name']).to eq 'Maria Luiza Pires'
      expect(json.first['exams'].first['type']).to eq 'hemácias'
      expect(json.first['exams'].first['limits']).to eq '45-52'
      expect(json.first['exams'].first['result']).to eq '97'
      expect(json.first['exams'].last['type']).to eq 'plaquetas'
      expect(json.first['exams'].last['limits']).to eq '11-93'
      expect(json.first['exams'].last['result']).to eq '97'

      expect(json.last['token']).to eq '0W9I67'
      expect(json.last['patient']['cpf']).to eq '048.108.026-04'
      expect(json.last['doctor']['crm']).to eq 'B0002IQM66'
      expect(json.last['exams'].first['result']).to eq '28'

      expect(json.first['patient']).not_to have_key 'address'
      expect(json.first['patient']).not_to have_key 'city'
      expect(json.first['patient']).not_to have_key 'state'
      expect(json.first['doctor']).not_to have_key 'email'
    end

    it 'returns a empty array if database has no registered test' do
      DatabaseTableManager.drop_all
      DatabaseTableManager.migrate

      get '/tests'

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq []
    end

    it 'returns a error message if database is not migrated' do
      DatabaseTableManager.drop_all

      get '/tests'

      expect(last_response.status).to eq 503
      expect(JSON.parse(last_response.body)['error'])
        .to include 'Database table not found'
    end

    it 'returns a error message if it fails to connect to the database' do
      allow(DatabaseConnectionManager)
        .to receive(:use_connection)
        .and_raise PG::ConnectionBad

      get '/tests'

      expect(last_response.status).to eq 503
      expect(JSON.parse(last_response.body)['error'])
        .to include 'Database connection failure'
    end
  end

  context 'GET /tests/:token' do
    it 'returns exam details for the given token' do
      DatabaseTableManager.drop_all
      DatabaseTableManager.migrate
      CSVImporter.import_to_database File.read './spec/fixtures/data.csv'

      get '/tests/0W9I67'

      expect(last_response).to be_ok
      json = JSON.parse last_response.body
      expect(json['token']).to eq '0W9I67'
      expect(json['date']).to eq '2021-07-09'
      expect(json['patient']['cpf']).to eq '048.108.026-04'
      expect(json['patient']['name']).to eq 'Juliana dos Reis Filho'
      expect(json['patient']['email']).to eq 'mariana_crist@kutch-torp.com'
      expect(json['patient']['birthdate']).to eq '1995-07-03'
      expect(json['patient']['address']).to eq '527 Rodovia Júlio'
      expect(json['patient']['city']).to eq 'Lagoa da Canoa'
      expect(json['patient']['state']).to eq 'Paraíba'
      expect(json['doctor']['crm']).to eq 'B0002IQM66'
      expect(json['doctor']['crm_state']).to eq 'SC'
      expect(json['doctor']['name']).to eq 'Maria Helena Ramalho'
      expect(json['doctor']['email']).to eq 'rayford@kemmer-kunze.info'
      expect(json['exams'].first['type']).to eq 'hemácias'
      expect(json['exams'].first['limits']).to eq '45-52'
      expect(json['exams'].first['result']).to eq '28'
    end

    it 'returns not found error if the token is not registered' do
      DatabaseTableManager.drop_all
      DatabaseTableManager.migrate

      get '/tests/RUBY42'

      expect(last_response).to be_not_found
      expect(JSON.parse(last_response.body)['error'])
        .to eq 'No exam with token RUBY42 found'
    end

    it 'returns a error message if database is not migrated' do
      DatabaseTableManager.drop_all

      get '/tests/0W9I67'

      expect(last_response.status).to eq 503
      expect(JSON.parse(last_response.body)['error'])
        .to include 'Database table not found'
    end

    it 'returns a error message if it fails to connect to the database' do
      allow(DatabaseConnectionManager)
        .to receive(:use_connection)
        .and_raise PG::ConnectionBad

      get '/tests/0W9I67'

      expect(last_response.status).to eq 503
      expect(JSON.parse(last_response.body)['error'])
        .to include 'Database connection failure'
    end
  end

  context 'GET /' do
    it 'returns a exam list html page' do
      get '/'

      expect(last_response).to be_ok
      expect(last_response.content_type).to include 'text/html'
      expect(last_response.body).to include 'Lista de Exames Médicos'
    end
  end

  context 'POST /import' do
    it 'successfully imports a csv file to the database' do
      DatabaseTableManager.drop_all
      DatabaseTableManager.migrate
      csv = File.read './spec/fixtures/post_data.csv'

      post '/import', csv, { 'CONTENT_TYPE' => 'text/csv' }
      all_exams = JSON.parse(ExamService.all_as_json)

      expect(last_response.status).to eq 201
      expect(last_response.content_type).to eq 'application/json'
      response_body = JSON.parse last_response.body
      expect(response_body['message']).to eq 'CSV imported to database'
      expect(all_exams.length).to eq 2
      expect(all_exams.last['token']).to eq 'O0RP5W'
      expect(all_exams.last['date']).to eq '2021-04-08'
      expect(all_exams.last['patient']['cpf']).to eq '094.010.477-66'
      expect(all_exams.last['patient']['name']).to eq 'Meire Paes'
      expect(all_exams.last['patient']['email']).to eq 'billie@ratke.co'
      expect(all_exams.last['patient']['birthdate']).to eq '1981-06-24'
      expect(all_exams.last['doctor']['crm']).to eq 'B00067668W'
      expect(all_exams.last['doctor']['crm_state']).to eq 'RS'
      expect(all_exams.last['doctor']['name']).to eq 'Félix Garcês'
      expect(all_exams.last['exams'].first['type']).to eq 'hemácias'
      expect(all_exams.last['exams'].first['limits']).to eq '45-52'
      expect(all_exams.last['exams'].first['result']).to eq '47'
      expect(all_exams.last['exams'].last['result']).to eq '51'
      expect(all_exams.first['token']).to eq 'YPV4AD'
      expect(all_exams.first['patient']['cpf']).to eq '066.126.400-90'
    end

    it 'returns a error message if database is not migrated' do
      DatabaseTableManager.drop_all
      csv = File.read './spec/fixtures/post_data.csv'

      post '/import', csv, { 'CONTENT_TYPE' => 'text/csv' }

      expect(last_response.status).to eq 503
      expect(JSON.parse(last_response.body)['error'])
        .to include 'Database table not found'
    end

    it 'returns a error message if it fails to connect to the database' do
      csv = File.read './spec/fixtures/post_data.csv'
      allow(DatabaseConnectionManager)
        .to receive(:use_connection)
        .and_raise PG::ConnectionBad

      post '/import', csv, { 'CONTENT_TYPE' => 'text/csv' }

      expect(last_response.status).to eq 503
      expect(JSON.parse(last_response.body)['error'])
        .to include 'Database connection failure'
    end
  end
end
