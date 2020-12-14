FROM rust:1.48-buster as builder

WORKDIR /usr/src/app
COPY . .

RUN cargo test \
    && cargo build --release

FROM debian:buster as app

WORKDIR /usr/bin/
COPY --from=builder /usr/src/app/target/release/rs-template .

ENTRYPOINT [ "rs-template" ]