class RequestMapper
  class << self
    def map_requests(rows)
      requests = {}

      rows.each do |row|
        token = row['request_token']
        requests[token] ||= build_request row
        add_exam_to_request requests[token], row
      end

      requests
    end

    def add_exam_to_request(request, row)
      return unless any_exam? row

      request['exams'] << {
        'type' => row['exam_type'],
        'limits' => row['exam_limits'],
        'result' => row['exam_result']
      }
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

    def build_full_request(row)
      {
        'token' => row['request_token'],
        'date' => row['request_date'],
        'patient' => build_full_patient(row),
        'doctor' => build_full_doctor(row),
        'exams' => []
      }
    end

    private

    def any_exam?(row)
      row['exam_type'] || row['exam_limits'] || row['exam_result']
    end

    def build_patient(row)
      {
        'cpf' => row['patient_cpf'],
        'name' => row['patient_name'],
        'email' => row['patient_email'],
        'birthdate' => row['patient_birthdate']
      }
    end

    def build_full_patient(row)
      {
        'cpf' => row['patient_cpf'],
        'name' => row['patient_name'],
        'email' => row['patient_email'],
        'birthdate' => row['patient_birthdate'],
        'address' => row['patient_address'],
        'city' => row['patient_city'],
        'state' => row['patient_state']
      }
    end

    def build_doctor(row)
      {
        'crm' => row['doctor_crm'],
        'crm_state' => row['doctor_state'],
        'name' => row['doctor_name']
      }
    end

    def build_full_doctor(row)
      {
        'crm' => row['doctor_crm'],
        'crm_state' => row['doctor_state'],
        'name' => row['doctor_name'],
        'email' => row['doctor_email']
      }
    end
  end
end
