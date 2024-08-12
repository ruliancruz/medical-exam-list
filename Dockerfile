FROM ruby:3.3.0

WORKDIR /app

COPY Gemfile ./
RUN bundle install

ENV RACK_ENV=development

CMD ["ruby", "server.rb"]