FROM ruby:3.3.0

COPY Gemfile ./
RUN bundle install

CMD ['ruby', 'server.rb']