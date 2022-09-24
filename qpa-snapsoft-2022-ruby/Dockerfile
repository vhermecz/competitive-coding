FROM ruby:3.1.0
RUN apt-get update -qq && apt-get install -y build-essential apt-utils
RUN mkdir /app
RUN echo 'gem: --no-document' >> ~/.gemrc
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN gem install bundler:2.3.22
RUN bundle install
ADD . /app
