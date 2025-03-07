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

FROM ruby:3.1.0 AS builder

WORKDIR /app

# Install dependencies (including MySQL client libraries for mysql2)
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    libmysqlclient-dev \  # Add MySQL client libraries
    curl \
    gnupg2 \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global yarn

# Copy only Gemfiles first for caching
COPY Gemfile Gemfile.lock ./ 

# Install the correct Bundler version before running bundle install
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

# Install runtime dependencies (including MySQL client libraries for mysql2)
RUN apt-get update -qq && apt-get install -y \
    postgresql-client \
    libmysqlclient-dev \  # Add MySQL client libraries
    curl \
    gnupg2 \
    && curl -sL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install --global yarn \
    && rm -rf /var/lib/apt/lists/*

# Copy built app from builder stage
COPY --from=builder /app /app

# Expose port
EXPOSE 3000

# Default command (override if needed for testing)
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

