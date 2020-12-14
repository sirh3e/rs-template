BUILD_DATE	:= $(shell date "+%Y-%m-%d")
CARGO 		:= cargo
VERSION_TAG	:= $(shell git describe --tags 2>/dev/null || git rev-parse --short HEAD)

.PHONY: all
all: cargo-run

.PHONY: cargo-release
cargo-release: clean cargo-test
	$(CARGO) build --release

.PHONY: cargo-run
cargo-run: cargo-test
	$(CARGO) run

.PHONY: cargo-test
cargo-test: cargo-build
	$(CARGO) test

.PHONY: cargo-build
cargo-build: cargo-fmt
	$(CARGO) build

.PHONY: cargo-fmt
cargo-fmt:
	$(CARGO) fmt

.PHONY: cargo-clean
cargo-clean:
	$(CARGO) clean

.PHONY: rust-clean
rust-clean:
	rm -vrf target/*

.PHONY: clean
clean: cargo-clean rust-clean