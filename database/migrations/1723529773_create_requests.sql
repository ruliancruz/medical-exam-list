CREATE TABLE requests (
  id SERIAL PRIMARY KEY,
  token VARCHAR(20),
  date DATE,
  patient_id INTEGER REFERENCES patients(id) ON DELETE SET NULL,
  doctor_id INTEGER REFERENCES doctors(id) ON DELETE SET NULL
);