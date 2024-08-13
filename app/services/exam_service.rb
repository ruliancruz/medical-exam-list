require './app/services/database_connection_manager'

class ExamService
  class << self
    def all_as_json
      rows = DatabaseConnectionManager.use_connection.exec(select_all_query)
      requests = map_requests(rows)
      requests.values.to_json
    end

    private

    def map_requests(rows)
      requests = {}

      rows.each do |row|
        token = row['request_token']
        requests[token] ||= build_request(row)
        add_exam_to_request(requests[token], row) if any_exam?(row)
      end

      requests
    end

    def any_exam?(row)
      row['exam_type'] || row['exam_limits'] || row['exam_result']
    end

    def build_request(row)
      {
        'token' => row['request_token'],
        'date' => row['request_date'],
        'patient' => build_patient(row),
        'doctor' => build_doctor(row),
        'exams' => []
      }
    end

    def build_patient(row)
      {
        'cpf' => row['patient_cpf'],
        'name' => row['patient_name'],
        'email' => row['patient_email'],
        'birthdate' => row['patient_birthdate']
      }
    end

    def build_doctor(row)
      {
        'crm' => row['doctor_crm'],
        'crm_state' => row['doctor_state'],
        'name' => row['doctor_name']
      }
    end

    def add_exam_to_request(request, row)
      request['exams'] << {
        'type' => row['exam_type'],
        'limits' => row['exam_limits'],
        'result' => row['exam_result']
      }
    end

    def select_all_query
      <<-SQL
        SELECT
          requests.token AS "request_token",
          requests.date AS "request_date",
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
          exams.type AS "exam_type",
          exams.limits AS "exam_limits",
          exams.result AS "exam_result"
        FROM exams
        JOIN requests ON exams.request_id = requests.id
        JOIN patients ON requests.patient_id = patients.id
        JOIN doctors ON requests.doctor_id = doctors.id
      SQL
    end
  end
end
