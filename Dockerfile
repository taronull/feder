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

COPY config/config.exs config/$MIX_ENV.exs config/

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

# Get basic tools.
RUN apk add --no-cache libstdc++ ncurses-libs openssl 

# Copy the app.
COPY --from=builder /app/_build/${MIX_ENV}/rel/feder ./

# Install LiteFS dependencies.
RUN apk add ca-certificates fuse3 sqlite

# Copy in the LiteFS binary and config.
COPY --from=flyio/litefs:0.5 /usr/local/bin/litefs /usr/local/bin/litefs
COPY litefs.yml /etc/litefs.yml

# Run LiteFS. Server gets started by /litefs.yml.
ENTRYPOINT litefs mount
