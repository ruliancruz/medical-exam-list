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
WHERE requests.token = $1