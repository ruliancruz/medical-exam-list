require 'csv'
require 'json'
require './app/services/database_connection_manager'

class ExamService
  def self.all_as_json
    connection = DatabaseConnectionManager.get_connection

    query = <<-SQL
      SELECT
        patients.cpf AS "patient_cpf",
        patients.name AS "patient_name",
        patients.email AS "patient_email",
        patients.birthdate AS "patient_birthdate",
        patients.address AS "patient_address",
        patients.city AS "patient_city",
        patients.state AS "patient_state",
        doctors.crm AS "doctor_crm",
        doctors.crm_state AS "doctor_state",
        doctors.name AS "doctor_name",
        doctors.email AS "doctor_email",
        exams.result_token AS "exam_result_token",
        exams.result_date AS "exam_result_date",
        exams.type AS "exam_type",
        exams.limits AS "exam_limits",
        exams.result AS "exam_result"
      FROM exams
      JOIN patients ON exams.patient_id = patients.id
      JOIN doctors ON exams.doctor_id = doctors.id
    SQL

    connection.exec(query).map { |row| row.transform_keys(&:to_s) }.to_json
  end
end
