# Start a builder.
FROM elixir:alpine AS builder

# Work in `/app` directory.
WORKDIR /app

# Set environment variable for production.
ENV MIX_ENV="prod"

# Get basic tools.
RUN apk add --no-cache build-base git

# Get package managers.
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy configurations.
RUN mkdir config

COPY config/base.exs config/$MIX_ENV.exs config/

# Get dependencies.
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

# Compile the dependencies.
RUN mix deps.compile

# Copy the app and digest its assets.
COPY lib lib
COPY priv priv
COPY assets assets
RUN mix assets.deploy

# Compile the app.
RUN mix compile

# Setup runtime.
COPY config/runtime.exs config/
COPY rel rel
RUN mix release

# Start a runner.
FROM elixir:alpine AS runner

# Work in `/app` directory.
WORKDIR /app

# Set environment variable for production.
ENV MIX_ENV="prod"

# Enable IPv6 network for Fly.io.
ENV ECTO_IPV6 true
ENV ERL_AFLAGS "-proto_dist inet6_tcp"

# Get basic tools.
RUN apk add --no-cache libstdc++ ncurses-libs openssl

# Copy the app.
COPY --from=builder /app/_build/${MIX_ENV}/rel/feder ./

# Start the container.
CMD bin/migrate && bin/server
