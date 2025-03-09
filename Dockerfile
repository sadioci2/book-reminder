# Stage 1: Build Stage
FROM ruby:3.1.0-slim AS builder
WORKDIR /app
# Install build tools and MariaDB dev libraries
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libmariadb-dev \
    && rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size
# Install specific Bundler version
RUN gem install bundler:2.3.3
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Stage 2: Runtime Stage
FROM ruby:3.1.0-slim
WORKDIR /app
# Install MariaDB runtime libs
RUN apt-get update -qq && apt-get install -y \
    libmariadb3 \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . .
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
