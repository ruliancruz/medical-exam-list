CREATE TABLE exams (
  id SERIAL PRIMARY KEY,
  result_token VARCHAR(20),
  result_date DATE,
  type VARCHAR(100),
  limits VARCHAR(20),
  result VARCHAR(10),
  patient_id INTEGER REFERENCES patients(id) ON DELETE SET NULL,
  doctor_id INTEGER REFERENCES doctors(id) ON DELETE SET NULL
);