build:
	docker build -t ruphin/webdev .
	docker push ruphin/webdev
.PHONY: build
