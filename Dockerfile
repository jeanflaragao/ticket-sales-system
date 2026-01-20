FROM ruby:3.2.2

ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# System dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  postgresql-client \
  git \
  curl \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install latest Bundler compatible with Rails 7.1
RUN gem install bundler

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# App source
COPY . .

# Rails runtime dirs
RUN mkdir -p tmp/pids log

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
