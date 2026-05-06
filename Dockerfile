FROM golang:1.25-alpine AS builder

WORKDIR /app

# Copy dependencies first (for caching)
COPY backend/go.mod backend/go.sum ./
RUN go mod download

# Copy full backend
COPY backend/ .

# Build correct entry point

ENV GOPROXY=https://proxy.golang.org,direct

RUN go build -o app ./cmd/api

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/app .

EXPOSE 8080

CMD ["./app"]
