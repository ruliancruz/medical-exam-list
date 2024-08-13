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
      first_patient = json.first['patient']
      first_doctor = json.first['doctor']
      first_exam = json.first['exam']

      expect(json.length).to eq 2
      expect(json.first['token']).to eq 'IQCZ17'
      expect(json.first['date']).to eq '2021-08-05'
      expect(first_patient['cpf']).to eq '048.973.170-88'
      expect(first_patient['name']).to eq 'Emilly Batista Neto'
      expect(first_patient['email']).to eq 'gerald.crona@ebert-quigley.com'
      expect(first_patient['birthdate']).to eq '2001-03-11'
      expect(first_patient['address']).to eq '165 Rua Rafaela'
      expect(first_patient['city']).to eq 'Ituverava'
      expect(first_patient['state']).to eq 'Alagoas'
      expect(first_doctor['crm']).to eq 'B000BJ20J4'
      expect(first_doctor['state']).to eq 'PI'
      expect(first_doctor['name']).to eq 'Maria Luiza Pires'
      expect(first_doctor['email']).to eq 'denna@wisozk.biz'
      expect(first_exam['type']).to eq 'hemácias'
      expect(first_exam['limits']).to eq '45-52'
      expect(first_exam['result']).to eq '97'
      expect(json.last['token']).to eq '0W9I67'
      expect(json.last['patient']['cpf']).to eq '048.108.026-04'
      expect(json.last['doctor']['crm']).to eq 'B0002IQM66'
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
end
