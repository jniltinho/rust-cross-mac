
.PHONY: all

all: build-docker


build-docker:
	docker build --no-cache -t ghcr.io/jniltinho/rust-cross-mac:latest -f Dockerfile .
	docker tag ghcr.io/jniltinho/rust-cross-mac:latest rust-cross-mac:latest
	docker images


build-bin:
	docker run -it --rm -v $(shell pwd):/opt/build -w/opt/build rust:slim-bullseye bash compile-bin.sh

push:
	docker push ghcr.io/jniltinho/rust-cross-mac:latest



prune:
	docker system prune --all --force --volumes


clean:
	docker rmi -f $(shell docker images -f 'dangling=true' -q --no-trunc|xargs) 2>/dev/null || true
	docker images



