FROM rust:1.86 AS builder
WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim
# Install any dependencies you may need (if your Rust binary requires any shared libraries)
# RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from the builder stage
COPY --from=builder /app/target/release/scrubs /usr/local/bin/scrubs

# Expose the port the app runs on (if applicable)
EXPOSE 3000

# Set the container's entrypoint to the binary
CMD ["/usr/local/bin/scrubs"]

