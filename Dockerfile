# Base image for dependencies
FROM ruby:3.1 AS builder

# Set working directory
WORKDIR /app

# Install essential OS dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn

# Copy only Gemfiles first to leverage Docker layer caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --jobs 4 --without development test

# Copy application source code
COPY . .

# Precompile assets (if the app has frontend assets)
RUN bundle exec rake assets:precompile

# ---------------------------------
# Final runtime image
# ---------------------------------
FROM ruby:3.1-slim

WORKDIR /app

# Install runtime dependencies
RUN apt-get update -qq && apt-get install -y \
    postgresql-client \
    nodejs \
    yarn && \
    rm -rf /var/lib/apt/lists/*

# Copy dependencies and application from the builder stage
COPY --from=builder /app /app

# Expose the default Rails port
EXPOSE 3000

# Set up entrypoint
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
