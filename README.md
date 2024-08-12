<div align="center">
  <h1>Medical Exam List</h1>
  <div>
    <img src="http://img.shields.io/static/v1?label=ruby&message=3.3.0&color=red&style=for-the-badge&logo=ruby"/>
    <img src="https://img.shields.io/static/v1?label=sinatra&message=4.0&color=red&style=for-the-badge&logo=redhat"/>
    <img src="https://img.shields.io/static/v1?label=postgreSQL&message=16.4&color=blue&style=for-the-badge&logo=postgresql&logoColor=white"/>
    <img src="http://img.shields.io/static/v1?label=test%20coverage&message=98.88%&color=green&style=for-the-badge"/>
    <img src="http://img.shields.io/static/v1?label=tests&message=6&color=green&style=for-the-badge"/>
    <img src="http://img.shields.io/static/v1?label=status&message=development&color=yellow&style=for-the-badge"/>
    <img src="http://img.shields.io/static/v1?label=license&message=unlicense&color=GREEN&style=for-the-badge"/>
  </div><br>

  Web application for medical examination listing.
</div>


## Table of Contents

:small_blue_diamond: [What The Application Can Do](#what-the-application-can-do)

:small_blue_diamond: [API Endpoints](#api-endpoints)

:small_blue_diamond: [Dependencies](#dependencies)

:small_blue_diamond: [How to Run the Application](#how-to-run-the-application)

:small_blue_diamond: [Gems Installed](#gems-installed)

:small_blue_diamond: [How to Run Tests](#how-to-run-tests)

:small_blue_diamond: [Entity-Relationship Diagram](#entity-relationship-diagram)

## What the Application Can Do

:heavy_check_mark: List medical exams

:heavy_check_mark: Import data from `.csv` files to database

## API Endpoints

### Exam List Endpoint

`GET /tests`

Returns full exam list data if it is registered on database.

Response Example:

```json
[
  {
    "patient_cpf": "048.973.170-88",
    "patient_name": "Emilly Batista Neto",
    "patient_email": "gerald.crona@ebert-quigley.com",
    "patient_birthdate": "2001-03-11",
    "patient_address": "165 Rua Rafaela",
    "patient_city": "Ituverava",
    "patient_state": "Alagoas",
    "doctor_crm": "B000BJ20J4",
    "doctor_state": "PI",
    "doctor_name": "Maria Luiza Pires",
    "doctor_email": "denna@wisozk.biz",
    "exam_result_token": "IQCZ17",
    "exam_result_date": "2021-08-05",
    "exam_type": "hemácias",
    "exam_limits": "45-52",
    "exam_result": "97"
  },
  {
    "patient_cpf": "048.973.170-88",
    "patient_name": "Emilly Batista Neto",
    "patient_email": "gerald.crona@ebert-quigley.com",
    "patient_birthdate": "2001-03-11",
    "patient_address": "165 Rua Rafaela",
    "patient_city": "Ituverava",
    "patient_state": "Alagoas",
    "doctor_crm": "B000BJ20J4",
    "doctor_state": "PI",
    "doctor_name": "Maria Luiza Pires",
    "doctor_email": "denna@wisozk.biz",
    "exam_result_token": "IQCZ17",
    "exam_result_date": "2021-08-05",
    "exam_type": "leucócitos",
    "exam_limits": "9-61",
    "exam_result": "89"
  }
]
```

## Dependencies

This application was made to run with [**Docker**](https://www.docker.com/), and the how to run instructions is writen to be used with it, so just use Docker, because everything you need will be installed on the containers.

:warning: [Ruby 3.3.0](https://rvm.io/)

:warning: [PostgreSQL 16.4](https://www.postgresql.org/)

:warning: [Node.js](https://nodejs.org/)

:warning: [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/)

:warning: [Bundler](https://bundler.io/)

## How to Run the Application

After installing Docker, clone this respository:

```
git clone https://github.com/ruliancruz/medical-exam-list.git
```

After that, all you need to do to run the application is starting Docker containers from application:

```
docker compose up --build app
```

Now you can access the application through http://localhost:3000/ route.

### Populating the Database

To populate the application's database from the default `.csv` file, run:

```
rake db:import_from_csv
```

You can change de default `.csv` path on DEFAULT_PATH constant on: `app/services/csv_importer.rb`

### Database Settings

For better security, I recommend you to change the default database credentials when using the application, you can do it change the environment variable values used on Docker on `.env` file:
```env
POSTGRES_USER=your_user
POSTGRES_PASSWORD=your_password
POSTGRES_DB=your_dbname

TEST_POSTGRES_USER=your_test_user
TEST_POSTGRES_PASSWORD=your_test_password
TEST_POSTGRES_DB=your_test_dbname

POSTGRES_VERSION=desired_postgre_version
```

Note that you can also change the PostgreSQL version if you want.

#### Additional Database Settings

There is other settings on `docker-compose.yml` like ports and pool connection size and timeout limit. If you want to change it, take a look on this file.

## Gems Installed

This is automatically installed when you start up Docker container or run Bundler, so you don't need to worry.

:gem: [Connection Pool](https://github.com/mperham/connection_pool)

:gem: [PG](https://deveiate.org/code/pg/README_md.html)

:gem: [Puma](https://github.com/puma/puma)

:gem: [Rack](https://github.com/rack/rack)

:gem: [Rack Test](https://github.com/rack/rack-test)

:gem: [RSpec](https://github.com/rspec/rspec-metagem)

:gem: [RuboCop](https://github.com/rubocop/rubocop)

:gem: [SimpleCov](https://github.com/simplecov-ruby/simplecov)

:gem: [Sinatra](https://github.com/sinatra/sinatra)

## How to Run Tests

This project was made using Test Driven Development.

It's recommended to run tests inside test containers for application and database on Docker. To do it you just need to run:

```
docker compose up --build test_app
```

Now you can run all the tests with:

```
rspec
```

## Entity-Relationship Diagram

![Entity-Relationship Diagram](https://github.com/user-attachments/assets/78837b81-ac95-4b76-8406-cc9e9947159d)
