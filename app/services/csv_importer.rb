require 'csv'
require './app/services/database/database_connection_manager'

COLUMN_SEPARATOR = ';'.freeze

EXPECTED_HEADERS = [
  'cpf',
  'nome paciente',
  'email paciente',
  'data nascimento paciente',
  'endereço/rua paciente',
  'cidade paciente',
  'estado patiente',
  'crm médico',
  'crm médico estado',
  'nome médico',
  'email médico',
  'token resultado exame',
  'data exame',
  'tipo exame',
  'limites tipo exame',
  'resultado tipo exame'
].freeze

class CSVImporter
  class << self
    def import_to_database(csv)
      csv_lines = CSV.parse csv, headers: true, col_sep: COLUMN_SEPARATOR, encoding: 'UTF-8'
      return false if csv_lines.headers != EXPECTED_HEADERS

      save_to_database csv
      true
    end

    private

    def save_to_database(csv)
      connection = DatabaseConnectionManager.use_connection

      CSV.parse(csv, headers: true, col_sep: COLUMN_SEPARATOR, encoding: 'UTF-8') do |row|
        patient_id = find_or_create_patient connection, patient_data(row)
        doctor_id = find_or_create_doctor connection, doctor_data(row)

        request_id = find_or_create_request(
          connection,
          request_data(row, patient_id, doctor_id)
        )

        create_exam connection, exam_data(row, request_id)
      end
    end

    def exam_data(row, request_id)
      {
        type: row['tipo exame'],
        limits: row['limites tipo exame'],
        result: row['resultado tipo exame'],
        request_id: request_id
      }
    end

    def request_data(row, patient_id, doctor_id)
      {
        token: row['token resultado exame'],
        date: row['data exame'],
        patient_id: patient_id,
        doctor_id: doctor_id
      }
    end

    def patient_data(row)
      {
        cpf: row['cpf'],
        name: row['nome paciente'],
        email: row['email paciente'],
        birthdate: row['data nascimento paciente'],
        address: row['endereço/rua paciente'],
        city: row['cidade paciente'],
        state: row['estado patiente']
      }
    end

    def doctor_data(row)
      {
        crm: row['crm médico'],
        crm_state: row['crm médico estado'],
        name: row['nome médico'],
        email: row['email médico']
      }
    end

    def create_exam(connection, exam_data)
      connection.exec_params(
        'INSERT INTO exams (type, limits, result, request_id) ' \
        'VALUES ($1, $2, $3, $4) RETURNING id',
        exam_data.values
      )
    end

    def find_or_create_request(connection, request_data)
      result = connection.exec_params(
        'SELECT id FROM requests WHERE token = $1', [request_data[:token]]
      )

      return result.first['id'] if result.ntuples.positive?

      connection.exec_params(
        'INSERT INTO requests (token, date, patient_id, doctor_id) ' \
        'VALUES ($1, $2, $3, $4) RETURNING id',
        request_data.values
      ).first['id']
    end

    def find_or_create_patient(connection, patient_data)
      result = connection.exec_params(
        'SELECT id FROM patients WHERE cpf = $1', [patient_data[:cpf]]
      )

      return result.first['id'] if result.ntuples.positive?

      connection.exec_params(
        'INSERT INTO patients (
          cpf, name, email, birthdate, address, city, state
        ) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id',
        patient_data.values
      ).first['id']
    end

    def find_or_create_doctor(connection, doctor_data)
      result = connection.exec_params(
        'SELECT id FROM doctors WHERE crm = $1 AND crm_state = $2',
        [doctor_data[:crm], doctor_data[:crm_state]]
      )

      return result.first['id'] if result.ntuples.positive?

      connection.exec_params(
        'INSERT INTO doctors (crm, crm_state, name, email) ' \
        'VALUES ($1, $2, $3, $4) RETURNING id',
        doctor_data.values
      ).first['id']
    end
  end
end
