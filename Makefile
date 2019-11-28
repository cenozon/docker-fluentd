IMAGE_VERSION=1.7.4-2019.11.28
IMAGE_NAME=cenozon/fluentd
FLUENTD_VERSION=v1.7.4-debian-2.0

all: build

prep:
	VERSION=${IMAGE_VERSION} FLUENTD_VERSION=${FLUENTD_VERSION} envsubst '$${VERSION} $${FLUENTD_VERSION}' < ./templates/Dockerfile.template > Dockerfile
	VERSION=${IMAGE_VERSION} FLUENTD_VERSION=${FLUENTD_VERSION} envsubst '$${VERSION} $${FLUENTD_VERSION}' < ./templates/README.md.template > README.md
	VERSION=${IMAGE_VERSION} FLUENTD_VERSION=${FLUENTD_VERSION} envsubst '$${VERSION} $${FLUENTD_VERSION}' < ./templates/fluent.conf.template > fluent.conf

build: prep
	docker build --no-cache --rm=true -t ${IMAGE_NAME}:${IMAGE_VERSION} .

run:
	docker run -p 9880:9880 -e ELASTIC_HOST=elastic-host -e ELASTIC_PORT=9200 --rm -it ${IMAGE_NAME}:${IMAGE_VERSION}

bash:
	docker run ${RUN_ARGS} bash
