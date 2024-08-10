FROM ruby:3.3.1

COPY Gemfile
RUN bundle install

CMD ['ruby', 'server.rb']