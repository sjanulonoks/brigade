.PHONY: build
build:
	go build -o bin/acid .

.PHONY: run
run: build
run:
	bin/acid

.PHONY: docker-build
docker-build:
	docker build -t acid-ubuntu:latest acidic/acid-ubuntu
	docker build -t acid-go:latest acidic/acid-go

.PHONY: docker-test
docker-test: docker-build
docker-test:
	docker run \
		-e CLONE_URL=https://github.com/Masterminds/structable.git \
		-e HEAD_COMMIT_ID=a1a302ef78ec3d85606dcf104a9a168542004036 \
		acid-ubuntu:latest

.PHONY: curl-test
curl-test:
	-kubectl delete pod run-unit-tests-a1a302ef78ec3d85606dcf104a9a168542004036
	-kubectl delete cm run-unit-tests-a1a302ef78ec3d85606dcf104a9a168542004036 && sleep 10
	curl -X POST localhost:7744/webhook/push -vvv -T ./structable.json
