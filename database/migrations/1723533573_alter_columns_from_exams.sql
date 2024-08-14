ALTER TABLE exams
DROP COLUMN result_token,
DROP COLUMN result_date,
DROP COLUMN doctor_id,
DROP COLUMN patient_id,
ADD COLUMN request_id INTEGER REFERENCES requests(id) ON DELETE SET NULL;