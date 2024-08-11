FROM ruby:3.3.0

WORKDIR /app

COPY Gemfile ./
RUN bundle install

CMD ["ruby", "server.rb"]