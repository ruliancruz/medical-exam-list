CREATE TABLE patients (
  id SERIAL PRIMARY KEY,
  cpf VARCHAR(14) UNIQUE,
  name VARCHAR(255),
  email VARCHAR(255),
  birthdate DATE,
  address VARCHAR(255),
  city VARCHAR(100),
  state VARCHAR(100)
);