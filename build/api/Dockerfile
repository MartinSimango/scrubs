FROM rust:1.86 AS builder
WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim

COPY --from=builder /app/target/release/scrubs /usr/local/bin/scrubs

EXPOSE 3000
CMD ["/usr/local/bin/scrubs"]

