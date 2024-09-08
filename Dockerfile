FROM ruby:3.3.0 AS base
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . /app

FROM base AS development
ENV RACK_ENV=development
CMD ["ruby", "server.rb"]

FROM base AS test
ENV RACK_ENV=test
CMD ["/bin/bash"]

FROM cypress/included:13.3.3 AS cypress
WORKDIR /app
COPY . /app
CMD ["npx", "cypress", "run", '--headless']