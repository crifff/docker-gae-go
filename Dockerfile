FROM alpine:3.5

RUN apk add --no-cache ca-certificates

ENV APPENGINE_VERSION=1.9.48
ENV HOME=/root
ENV SDK=https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-${APPENGINE_VERSION}.zip \
    PACKAGES="curl unzip git python nodejs py-pygments" \
    GOPATH=${HOME}/go_appengine/gopath \
    GOROOT=${HOME}/go_appengine/goroot \
    PATH=${HOME}/go_appengine:${HOME}/go_appengine/gopath/bin:${PATH} 

# Install appengine Go SDK
RUN apk add --update --no-cache ${PACKAGES}
RUN curl -fo /tmp/gae.zip ${SDK} && unzip -q /tmp/gae.zip -d /tmp/ && mv /tmp/go_appengine  ${HOME}/go_appengine && rm /tmp/gae.zip

# Install Hugo
ENV HUGO_VERSION 0.19
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit

RUN mkdir /usr/local/hugo
ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /usr/local/hugo/
RUN tar xzf /usr/local/hugo/${HUGO_BINARY}.tar.gz -C /usr/local/hugo/ \
	&& ln -s /usr/local/hugo/hugo_${HUGO_VERSION}_linux_amd64/hugo_${HUGO_VERSION}_linux_amd64 /usr/local/bin/hugo \
	&& rm /usr/local/hugo/${HUGO_BINARY}.tar.gz

# Install util
RUN npm install -g yarn
RUN goapp get github.com/jstemmer/go-junit-report
