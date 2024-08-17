<div align="center">
  <h1>Medical Exam List</h1>
  <div>
    <img src="https://img.shields.io/static/v1?label=ruby&message=3.3.0&color=red&style=for-the-badge&logo=ruby"/>
    <img src="https://img.shields.io/static/v1?label=sinatra&message=4.0&color=red&style=for-the-badge&logo=redhat"/>
    <img src="https://img.shields.io/static/v1?label=javascript&message=es6&color=yellow&style=for-the-badge&logo=javascript"/>
    <img src="https://img.shields.io/static/v1?label=postgresql&message=16.4&color=blue&style=for-the-badge&logo=postgresql&logoColor=white"/>
    <img src="https://img.shields.io/static/v1?label=redis&message=7.4.0&color=red&style=for-the-badge&logo=redis&logoColor=white"/>
    <img src="https://img.shields.io/static/v1?label=cypress&message=13.3.3&color=GREEN&style=for-the-badge&logo=cypress&logoColor=white"/>
    <img src="https://img.shields.io/static/v1?label=test%20coverage&message=95.29%&color=green&style=for-the-badge"/>
    <img src="https://img.shields.io/static/v1?label=tests&message=24&color=green&style=for-the-badge"/>
    <img src="https://img.shields.io/static/v1?label=status&message=development&color=yellow&style=for-the-badge"/>
    <img src="https://img.shields.io/static/v1?label=license&message=unlicense&color=GREEN&style=for-the-badge"/>
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

:heavy_check_mark: List medical exams on JSON through API

:heavy_check_mark: Show medical exam details on JSON through API

:heavy_check_mark: List medical exams on web page

:heavy_check_mark: Show exam details on web page

:heavy_check_mark: Import data from CSV files to database

:heavy_check_mark: Show background jobs dashboard

### Application Homepage Image

![image](https://github.com/user-attachments/assets/001148a0-80c6-4d67-bd36-a33bc72edd80)


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

### Exam Details Endpoint

`GET /tests/:token`

Returns the exam details of the informed token. Returns not found if no exam is found for the given token.

Response Example:

```json
{
  "token": "IQCZ17",
  "date": "2021-08-05",
  "patient": {
    "cpf": "048.973.170-88",
    "name": "Emilly Batista Neto",
    "email": "gerald.crona@ebert-quigley.com",
    "birthdate": "2001-03-11",
    "address": "165 Rua Rafaela",
    "city": "Ituverava",
    "state": "Alagoas"
  },
  "doctor": {
    "crm": "B000BJ20J4",
    "crm_state": "PI",
    "name": "Maria Luiza Pires",
    "email": "denna@wisozk.biz"
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
}
```

### CSV Import Endpoint

`POST /import`

Import CSV content from the request body to the database.

Request Example:
```
cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame
066.126.400-90;Matheus Barroso;maricela@streich.com;1972-03-09;9378 Rua Stella Braga;Senador Elói de Souza;Pernambuco;B000AR99QO;MS;Oliver Palmeira;lawana.erdman@waters.info;YPV4AD;2021-08-12;ácido úrico;15-61;64
094.010.477-66;Meire Paes;billie@ratke.co;1981-06-24;7187 Rua Mariah;Rio Negro;Roraima;B00067668W;RS;Félix Garcês;letty@herzog.name;O0RP5W;2021-04-08;hemácias;45-52;47
094.010.477-66;Meire Paes;billie@ratke.co;1981-06-24;7187 Rua Mariah;Rio Negro;Roraima;B00067668W;RS;Félix Garcês;letty@herzog.name;O0RP5W;2021-04-08;leucócitos;9-61;51
```

Response Example:

```json
{
  "message": "CSV imported to database"
}
```

You need to follow this CSV headers:

```
cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado patiente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame
```

## Dependencies

This application was made to run with [**Docker**](https://www.docker.com/), and the how to run instructions is writen to be used with it, so just use Docker, because everything you need will be installed on the containers.

:warning: [Ruby 3.3.0](https://rvm.io/)

:warning: [PostgreSQL 16.4](https://www.postgresql.org/)

:warning: [Redis 7.4.0](https://redis.io/)

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
docker compose up --build
```

It will start test containers too, if want only the main application, run it instead:

```
docker compose up --build sidekiq
```

Now you can access the application through http://localhost:3000/ route.

You can change the route on `HOST` environment variable on docker compose file.

### Populating the Database

To drop and populate the application's database data from the default `.csv` file, run:

```
rake db:import_from_csv
```

You can change de default `.csv` path on CSV_PATH constant on: `Rakefile`

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

#### Background Jobs Dashboard

This application uses [**Sidekiq**](https://github.com/sidekiq/sidekiq) for background jobs to import CSV files. If you want to use it's dashboard, just access `/sidekiq` page and enter the sidekiq credentials to see it.

You can change the credentials on `docker-compose.yml` on app container:

```env
SIDEKIQ_USERNAME: sidekiq
SIDEKIQ_PASSWORD: sidekiq123
```

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

:gem: [Redis](https://github.com/redis/redis-rb)

:gem: [RSpec](https://github.com/rspec/rspec-metagem)

:gem: [RuboCop](https://github.com/rubocop/rubocop)

:gem: [SimpleCov](https://github.com/simplecov-ruby/simplecov)

:gem: [Sidekiq](https://github.com/sidekiq/sidekiq)

:gem: [Sinatra](https://github.com/sinatra/sinatra)

:gem: [Tempfile](https://github.com/ruby/tempfile)

## How to Run Tests

This project uses [**RSpec**](https://rspec.info/) for request and unit tests and [**Cypress**](https://www.cypress.io/) for system tests.

It's recommended to run tests inside test containers for application and database on Docker. To do it you just need to run:

```
docker compose up --build test_app
```

Now you can run all the request and unit tests with:

```
rspec
```

For the system tests, the Cypress runs on a separated container from the RSpec, you can run these tests with:

```
docker compose up --build cypress
```

When running it very often, you may come across the max depth exceeded error, you can solve it cleaning your docker image list, so if it happens try to run these commands:

```
docker image prune
```

Or:

```
docker rmi -f $(docker images -q)
```

## Entity-Relationship Diagram

![Entity-Relationship Diagram](https://github.com/user-attachments/assets/e4501ff4-424e-45c4-a16e-dadb645e6a36)
