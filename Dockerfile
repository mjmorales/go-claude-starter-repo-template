# syntax=docker/dockerfile:1.4

# Build stage
FROM golang:1.23-alpine AS builder

# Install build dependencies
RUN apk add --no-cache \
    git \
    make \
    gcc \
    musl-dev \
    ca-certificates \
    tzdata

# Set build arguments for metadata
ARG SERVICE=example-service
ARG VERSION=dev
ARG COMMIT=unknown
ARG BUILD_TIME

# Set working directory
WORKDIR /build

# Cache dependencies separately for better layer caching
COPY go.mod go.sum ./
RUN --mount=type=cache,target=/go/pkg/mod \
    go mod download && go mod verify

# Copy source code
COPY . .

# Build the application with optimizations
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/root/.cache/go-build \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build \
    -trimpath \
    -ldflags="-w -s \
        -X main.version=${VERSION} \
        -X main.commit=${COMMIT} \
        -X main.buildTime=${BUILD_TIME} \
        -X main.service=${SERVICE} \
        -extldflags '-static'" \
    -a -installsuffix cgo \
    -o /build/app \
    ./cmd/${SERVICE}

# Create minimal nsswitch.conf for proper DNS resolution
RUN echo 'hosts: files dns' > /etc/nsswitch.conf

# Final stage - distroless for minimal attack surface
FROM gcr.io/distroless/static-debian12:nonroot AS production

# Copy timezone data for proper time handling
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

# Copy nsswitch.conf for DNS resolution
COPY --from=builder /etc/nsswitch.conf /etc/nsswitch.conf

# Copy the binary
COPY --from=builder --chown=nonroot:nonroot /build/app /app

# Set environment defaults
ENV TZ=UTC \
    LOG_LEVEL=info \
    LOG_FORMAT=json

# Expose port (adjust as needed)
EXPOSE 8080 9090

# Use non-root user (uid: 65532)
USER nonroot:nonroot

# Health check with proper timeout
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD ["/app", "health"] || exit 1

# Set entrypoint
ENTRYPOINT ["/app"]

# =============================================================================
# Development stage - with debugging tools
# =============================================================================
FROM golang:1.23-alpine AS development

# Install development tools
RUN apk add --no-cache \
    git \
    make \
    gcc \
    musl-dev \
    curl \
    vim \
    bash \
    postgresql-client \
    redis

# Install air for hot reload
RUN go install github.com/air-verse/air@latest

# Install dlv for debugging
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Set working directory
WORKDIR /app

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Expose ports for app and debugger
EXPOSE 8080 9090 2345

# Default to running with air
CMD ["air", "-c", ".air.toml"]

# =============================================================================
# Debug stage - production image with debug capabilities
# =============================================================================
FROM alpine:3.22 AS debug

# Install debugging tools
RUN apk add --no-cache \
    ca-certificates \
    tzdata \
    curl \
    wget \
    netcat-openbsd \
    bind-tools \
    busybox-extras \
    postgresql-client \
    redis \
    jq

# Create non-root user
RUN addgroup -g 1000 app && \
    adduser -u 1000 -G app -s /bin/sh -D app

WORKDIR /app

# Copy binary from builder
COPY --from=builder --chown=app:app /build/app /app/app

# Switch to non-root user
USER app

# Expose ports
EXPOSE 8080 9090

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD ["/app/app", "health"] || exit 1

ENTRYPOINT ["/app/app"]