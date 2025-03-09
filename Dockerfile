# # Stage 1: Build Stage
# FROM ruby:3.1.0-slim AS builder
# WORKDIR /app
# # Install build tools and MariaDB dev libraries
# RUN apt-get update -qq && apt-get install -y \
#     build-essential \
#     libmariadb-dev \
#     && rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size
# # Install specific Bundler version
# RUN gem install bundler:2.3.3
# COPY Gemfile Gemfile.lock ./
# RUN bundle install

# # Stage 2: Runtime Stage
# FROM ruby:3.1.0-slim
# WORKDIR /app
# # Install MariaDB runtime libs
# RUN apt-get update -qq && apt-get install -y \
#     libmariadb3 \
#     && rm -rf /var/lib/apt/lists/*
# COPY --from=builder /usr/local/bundle /usr/local/bundle
# COPY . .
# EXPOSE 3000
# CMD ["rails", "server", "-b", "0.0.0.0"]

# FROM Ruby image
FROM ruby:3.1.0 AS builder

WORKDIR /app

# Install dependencies (add libreadline-dev for io-console to install)
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    curl \
    libvips-dev \
    libreadline-dev \
    libssl-dev \
    default-mysql-client && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# Copy only Gemfiles first for caching
COPY Gemfile Gemfile.lock ./

# Install Bundler, and then the gems
RUN gem install bundler -v 2.3.3 && \
    bundle config set --local without 'production' && \
    bundle install --jobs 4

# Copy the rest of the application
COPY . .

# Precompile assets for production (if needed)
RUN bundle exec rake assets:precompile

# -----------------------
# Final runtime image
# -----------------------
FROM ruby:3.1.0-slim  

WORKDIR /app

# Install runtime dependencies (add libreadline-dev for io-console to work)
RUN apt-get update -qq && apt-get install -y \
    postgresql-client \
    nodejs \
    yarn \
    curl \
    libvips-dev \
    libreadline-dev \
    libssl-dev \
    default-mysql-client && \
    rm -rf /var/lib/apt/lists/*  # Clean up in the runtime image as well

# Copy built app from builder stage
COPY --from=builder /app /app

# Expose port for the Rails app
EXPOSE 3000

# Default command to start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


