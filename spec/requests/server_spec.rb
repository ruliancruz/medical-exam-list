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
      expect(json.first['patient_cpf']).to eq '048.973.170-88'
      expect(json.first['patient_name']).to eq 'Emilly Batista Neto'
      expect(json.first['patient_email']).to eq 'gerald.crona@ebert-quigley.com'
      expect(json.first['patient_birthdate']).to eq '2001-03-11'
      expect(json.first['patient_address']).to eq '165 Rua Rafaela'
      expect(json.first['patient_city']).to eq 'Ituverava'
      expect(json.first['patient_state']).to eq 'Alagoas'
      expect(json.first['doctor_crm']).to eq 'B000BJ20J4'
      expect(json.first['doctor_state']).to eq 'PI'
      expect(json.first['doctor_name']).to eq 'Maria Luiza Pires'
      expect(json.first['doctor_email']).to eq 'denna@wisozk.biz'
      expect(json.first['exam_result_token']).to eq 'IQCZ17'
      expect(json.first['exam_result_date']).to eq '2021-08-05'
      expect(json.first['exam_type']).to eq 'hemácias'
      expect(json.first['exam_limits']).to eq '45-52'
      expect(json.first['exam_result']).to eq '97'
      expect(json.last['patient_cpf']).to eq '048.108.026-04'
      expect(json.last['doctor_crm']).to eq 'B0002IQM66'
      expect(json.last['exam_result_token']).to eq '0W9I67'
    end

    it 'returns a empty array if database has no registered test' do
      DatabaseTableManager.drop_all
      DatabaseTableManager.migrate

      get '/tests'

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq []
    end
  end
end
