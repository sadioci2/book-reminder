# Use the Ruby 3.1.0 image as base
FROM ruby:3.1.0 AS builder

WORKDIR /app

# Install required dependencies for compiling gems with native extensions
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    curl \
    libvips-dev \
    libreadline-dev \
    libssl-dev \
    libmariadb-dev \
    libncurses5-dev \
    libncurses-dev && \
    rm -rf /var/lib/apt/lists/*  # Clean up after installation

# Copy Gemfile and Gemfile.lock first for better caching
COPY Gemfile Gemfile.lock ./

# Install bundler
RUN gem install bundler -v 2.3.3

# Install all gems including the debug gem which depends on io-console
RUN bundle install --jobs 4

# Copy the rest of the application files
COPY . .

# -----------------------
# Final runtime image
# -----------------------
FROM ruby:3.1.0-slim  

WORKDIR /app

# Install runtime dependencies for the slim image
RUN apt-get update -qq && apt-get install -y \
    postgresql-client \
    nodejs \
    yarn \
    curl \
    libvips-dev \
    libreadline-dev \
    libssl-dev \
    libmariadb-dev \
    libncurses5-dev && \
    rm -rf /var/lib/apt/lists/*  # Clean up to reduce image size

# Copy built application from builder stage
COPY --from=builder /app /app

# Expose port for Rails
EXPOSE 3000

# Default command to run the Rails app
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
