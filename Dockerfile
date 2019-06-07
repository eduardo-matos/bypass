FROM ruby:2.6-alpine

COPY . /app
WORKDIR /app

RUN gem install bundler -v 2.0.1 && bundle

CMD [ "ruby", "app.rb" ]