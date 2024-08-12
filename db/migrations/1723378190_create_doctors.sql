CREATE TABLE doctors (
  id SERIAL PRIMARY KEY,
  crm VARCHAR(10),
  crm_state VARCHAR(2),
  name VARCHAR(255),
  email VARCHAR(255)
);