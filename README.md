<div align="center">
  <h1>Medical Exam List</h1>
  <div>
    <img src="http://img.shields.io/static/v1?label=ruby&message=3.3.0&color=red&style=for-the-badge&logo=ruby"/>
    <img src="https://img.shields.io/static/v1?label=sinatra&message=4.0&color=red&style=for-the-badge&logo=redhat"/>
    <img src="https://img.shields.io/static/v1?label=postgreSQL&message=16.4&color=blue&style=for-the-badge&logo=postgresql&logoColor=white"/>
    <img src="http://img.shields.io/static/v1?label=test%20coverage&message=99.11%&color=green&style=for-the-badge"/>
    <img src="http://img.shields.io/static/v1?label=tests&message=7&color=green&style=for-the-badge"/>
    <img src="http://img.shields.io/static/v1?label=status&message=development&color=yellow&style=for-the-badge"/>
    <img src="http://img.shields.io/static/v1?label=license&message=unlicense&color=GREEN&style=for-the-badge"/>
  </div><br>

  Web application for medical examination listing.
</div>


## Table of Contents

:small_blue_diamond: [What The Application Can Do](#what-the-application-can-do)

:small_blue_diamond: [API Endpoints](#api-endpoints)

:small_blue_diamond: [Page URLs](#page-urls)

:small_blue_diamond: [Dependencies](#dependencies)

:small_blue_diamond: [How to Run the Application](#how-to-run-the-application)

:small_blue_diamond: [Gems Installed](#gems-installed)

:small_blue_diamond: [How to Run Tests](#how-to-run-tests)

:small_blue_diamond: [Entity-Relationship Diagram](#entity-relationship-diagram)

## What the Application Can Do

:heavy_check_mark: List medical exams on JSON through API

:heavy_check_mark: List medical exams on web page

:heavy_check_mark: Import data from `.csv` files to database

## API Endpoints

### Exam List Endpoint

`GET /tests`

Returns full exam list data if it is registered on database.

Response Example:

```json
[
  {
    "token": "IQCZ17",
    "date": "2021-08-05",
    "patient": {
      "cpf": "048.973.170-88",
      "name": "Emilly Batista Neto",
      "email": "gerald.crona@ebert-quigley.com",
      "birthdate": "2001-03-11"
    },
    "doctor": {
      "crm": "B000BJ20J4",
      "crm_state": "PI",
      "name": "Maria Luiza Pires"
    },
    "exams": [
      {
        "type": "hemácias",
        "limits": "45-52",
        "result": "97"
      },
      {
        "type": "leucócitos",
        "limits": "9-61",
        "result": "89"
      },
      {
        "type": "plaquetas",
        "limits": "11-93",
        "result": "97"
      },
      {
        "type": "hdl",
        "limits": "19-75",
        "result": "0"
      }
    ]
  },
  {
    "token": "0W9I67",
    "date": "2021-07-09",
    "patient": {
      "cpf": "048.108.026-04",
      "name": "Juliana dos Reis Filho",
      "email": "mariana_crist@kutch-torp.com",
      "birthdate": "1995-07-03"
    },
    "doctor": {
      "crm": "B0002IQM66",
      "crm_state": "SC",
      "name": "Maria Helena Ramalho"
    },
    "exams": [
      {
        "type": "hemácias",
        "limits": "45-52",
        "result": "28"
      },
      {
        "type": "leucócitos",
        "limits": "9-61",
        "result": "91"
      },
      {
        "type": "plaquetas",
        "limits": "11-93",
        "result": "18"
      }
    ]
  }
]
```

## Page URLs

### Exam List Page

`GET /exams`

Returns a web page showing `GET /tests` endpoint formatted data.

## Dependencies

This application was made to run with [**Docker**](https://www.docker.com/), and the how to run instructions is writen to be used with it, so just use Docker, because everything you need will be installed on the containers.

:warning: [Ruby 3.3.0](https://rvm.io/)

:warning: [PostgreSQL 16.4](https://www.postgresql.org/)

:warning: [Node.js](https://nodejs.org/)

:warning: [Yarn](https://classic.yarnpkg.com/lang/en/docs/install/)

:warning: [Bundler](https://bundler.io/)

## How to Run the Application

After configuring Docker, clone this respository:

```
git clone https://github.com/ruliancruz/medical-exam-list.git
```

After that, all you need to do to run the application is starting Docker containers from application:

```
docker compose up --build app
```

Now you can access the application through http://localhost:3000/ route.

### Populating the Database

To drop and populate the application's database data from the default `.csv` file, run:

```
rake db:import_from_csv
```

You can change de default `.csv` path on DEFAULT_PATH constant on: `app/services/csv_importer.rb`

#### Alternatively you can run the tasks separately

To drop all tables run:

```
rake db:drop
```

To run all migrations do:

```
rake db:import_from_csv
```

And to import data from `.csv` run:

```
rake db:import
```

The `rake db:import_from_csv` works running the other 3 tasks together.

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

![Entity-Relationship Diagram](https://github.com/user-attachments/assets/e4501ff4-424e-45c4-a16e-dadb645e6a36)
