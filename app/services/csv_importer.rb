require 'csv'
require './app/services/database_connection_manager.rb'

COLUMN_SEPARATOR = ';'.freeze
DEFAULT_PATH = './storage/data.csv'.freeze

class CSVImporter
  class << self
    def import_to_database csv_path = DEFAULT_PATH
      connection = DatabaseConnectionManager.get_connection

      CSV.foreach(csv_path, headers: true, col_sep: COLUMN_SEPARATOR) do |row|
        patient_data = {
          cpf: row['cpf'],
          name: row['nome paciente'],
          email: row['email paciente'],
          birthdate: row['data nascimento paciente'],
          address: row['endereço/rua paciente'],
          city: row['cidade paciente'],
          state: row['estado patiente']
        }

        doctor_data = {
          crm: row['crm médico'],
          crm_state: row['crm médico estado'],
          name: row['nome médico'],
          email: row['email médico']
        }

        exam_data = {
          result_token: row['token resultado exame'],
          result_date: row['data exame'],
          type: row['tipo exame'],
          limits: row['limites tipo exame'],
          result: row['resultado tipo exame']
        }

        patient_id = find_or_create_patient(connection, patient_data)
        doctor_id = find_or_create_doctor(connection, doctor_data)

        insert_query = <<-SQL
          INSERT INTO exams (
            result_token,
            result_date,
            type,
            limits,
            result,
            patient_id,
            doctor_id
          ) VALUES ($1, $2, $3, $4, $5, $6, $7)
        SQL

        connection.exec_params(
          insert_query,
          [
            exam_data[:result_token],
            exam_data[:result_date],
            exam_data[:type],
            exam_data[:limits],
            exam_data[:result],
            patient_id,
            doctor_id
          ]
        )
      end
    end

    private
    def find_or_create_patient connection, patient_data
      result = connection.exec_params(
        "SELECT id FROM patients WHERE cpf = $1",
        [patient_data[:cpf]]
      )

      return result[0]['id'] if result.ntuples > 0

      insert_query = <<-SQL
        INSERT INTO patients (
          cpf,
          name,
          email,
          birthdate,
          address,
          city,
          state
        ) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id
      SQL

      connection.exec_params(
        insert_query,
        [
          patient_data[:cpf],
          patient_data[:name],
          patient_data[:email],
          patient_data[:birthdate],
          patient_data[:address],
          patient_data[:city],
          patient_data[:state]
        ]
      )[0]['id']
    end

    def find_or_create_doctor connection, doctor_data
      result = connection.exec_params(
        "SELECT id FROM doctors WHERE crm = $1 AND crm_state = $2",
        [doctor_data[:crm], doctor_data[:crm_state]]
      )

      return result[0]['id'] if result.ntuples > 0

      connection.exec_params(
        "INSERT INTO doctors (crm, crm_state, name, email) " \
        "VALUES ($1, $2, $3, $4) RETURNING id",
        [
          doctor_data[:crm],
          doctor_data[:crm_state],
          doctor_data[:name],
          doctor_data[:email]
        ]
      )[0]['id']
    end
  end
end
