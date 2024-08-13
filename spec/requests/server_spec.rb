require 'rack/test'
require './server'
require './app/services/database_table_manager'
require './app/services/csv_importer'

RSpec.describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'GET /tests' do
    it 'returns a test list' do
      DatabaseTableManager.drop_all
      DatabaseTableManager.migrate
      CSVImporter.import_to_database './spec/fixtures/data.csv'

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

  context 'GET /exams' do
    it 'returns a exam list html page' do
      get '/exams'

      expect(last_response).to be_ok
      expect(last_response.content_type).to include 'text/html'
      expect(last_response.body).to include 'Lista de Exames Médicos'
    end
  end
end
