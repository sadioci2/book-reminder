# # Use the specific Ruby version from Gemfile
# FROM ruby:3.1.0 AS builder

# WORKDIR /app

# # Install dependencies
# RUN apt-get update -qq && apt-get install -y \
#     build-essential \
#     libpq-dev \
#     nodejs \
#     yarn

# # Copy only Gemfiles first for caching
# COPY Gemfile Gemfile.lock ./ 

# # Install the correct Bundler version before running bundle install
# RUN gem install bundler -v 2.3.3 && \
#     bundle config set --local without 'production' && \
#     bundle install --jobs 4

# # Copy the rest of the application
# COPY . .

# # Precompile assets for production (if needed)
# RUN bundle exec rake assets:precompile

# # -----------------------
# # Final runtime image
# # -----------------------
# FROM ruby:3.1.0-slim  

# WORKDIR /app

# # Install runtime dependencies
# RUN apt-get update -qq && apt-get install -y \
#     postgresql-client \
#     nodejs \
#     yarn && \
#     rm -rf /var/lib/apt/lists/*

# # Copy built app from builder stage
# COPY --from=builder /app /app

# # Expose port
# EXPOSE 3000

# # Default command (override if needed for testing)
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

# Use the specific Ruby version from Gemfile
# FROM ruby:3.1.0 AS builder

# WORKDIR /app

# # Install dependencies
# RUN apt-get update -qq && apt-get install -y \
#     build-essential \
#     libpq-dev \
#     nodejs \
#     yarn \
#     curl \
#     libvips-dev # (Optional, if using image processing like ImageMagick)

# # Copy only Gemfiles first for caching
# COPY Gemfile Gemfile.lock ./ 

# # Install the correct Bundler version before running bundle install
# RUN gem install bundler -v 2.3.3 && \
#     bundle config set --local without 'production' && \
#     bundle install --jobs 4

# # Copy the rest of the application
# COPY . .

# # Precompile assets for production (if needed)
# RUN bundle exec rake assets:precompile

# # -----------------------
# # Final runtime image
# # -----------------------
# FROM ruby:3.1.0-slim  

# WORKDIR /app

# # Install runtime dependencies
# RUN apt-get update -qq && apt-get install -y \
#     postgresql-client \
#     nodejs \
#     yarn \
#     curl \
#     libvips-dev && \
#     rm -rf /var/lib/apt/lists/*

# # Copy built app from builder stage
# COPY --from=builder /app /app

# # Expose port
# EXPOSE 3000

# # Default command (override if needed for testing)
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

# Use the specific Ruby version from Gemfile
# Use the specific Ruby version from Gemfile
# Use the specific Ruby version from Gemfile
# Use the specific Ruby version from Gemfile
# -----------------------
# Build stage
# -----------------------
# -----------------------
# Build stage
# -----------------------
# -----------------------
# Build stage
# -----------------------
# -----------------------
# Build stage
# -----------------------
FROM ruby:3.1.0 AS builder

WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ruby-dev \
    libpq-dev \
    nodejs \
    yarn \
    curl \
    libvips-dev \
    libreadline-dev \
    libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Force install io-console separately
RUN gem install io-console -v 0.5.11

# Copy only Gemfiles first for caching
COPY Gemfile Gemfile.lock ./ 

# Install the correct Bundler version before running bundle install
RUN gem install bundler -v 2.3.3 && \
    bundle config set --local without 'production' && \
    bundle install --jobs 4 --retry 3

# Copy the rest of the application
COPY . .

# Precompile assets for production (if needed)
RUN bundle exec rake assets:precompile || echo "Skipping assets precompilation"

# -----------------------
# Final runtime image
# -----------------------
FROM ruby:3.1.0-slim  

WORKDIR /app

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    postgresql-client \
    nodejs \
    yarn \
    curl \
    libvips-dev \
    libreadline-dev \
    libssl-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy built app from builder stage
COPY --from=builder /app /app

# Expose port
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]


