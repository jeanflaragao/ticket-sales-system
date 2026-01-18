FROM ruby:3.2.2

RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      libpq-dev \
      nodejs \
      npm \
      postgresql-client && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./

# Fix platform issue BEFORE bundle install
RUN bundle lock --add-platform x86_64-linux && \
    bundle lock --add-platform aarch64-linux && \
    bundle install --jobs 4 --retry 3

COPY . .

RUN mkdir -p tmp/pids log

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]