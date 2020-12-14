APP_BUILD_DATE	:= $(shell date "+%Y-%m-%d")
APP_NAME		:= $(notdir $(shell pwd))
APP_VERSION_TAG	:= $(shell git describe --tags 2>/dev/null || git rev-parse --short HEAD)

CARGO 			:= cargo

CONTAINER=docker #or podman

#Container versioning
# rust:1.48-buster = CONTAINER_TAG
# rust:1.48-buster = CONTAINER_TAG_LATEST
# rust:1.48-buster = CONTAINER_TAG_NAME:CONTAINER_TAG_VERSION

CONTAINER_TAG_NAME=$(APP_NAME)
CONTAINER_TAG_VERSION=$(APP_VERSION_TAG)

CONTAINER_TAG=$(CONTAINER_TAG_NAME):$(CONTAINER_TAG_VERSION)
CONTAINER_TAG_LATEST=$(CONTAINER_TAG_NAME):latest

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

.PHONY: container-run
container-run: container-build
	$(CONTAINER) run $(CONTAINER_TAG_LATEST)

.PHONY: container-build
container-build: container-prepare
	$(CONTAINER) build \
		--tag $(CONTAINER_TAG) \
		--tag $(CONTAINER_TAG_LATEST) \
		.

.PHONY: container-clean
container-clean:
	$(CONTAINER) image rm --force $(CONTAINER_TAG)
	$(CONTAINER) image rm --force $(CONTAINER_TAG_LATEST)

.PHONY: container-prepare
container-prepare:
	cp .gitignore .dockerignore

.PHONY: rust-clean
rust-clean:
	rm -rf target/*

.PHONY: clean
clean: cargo-clean container-clean rust-clean