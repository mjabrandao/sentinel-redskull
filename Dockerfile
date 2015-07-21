FROM redis:latest

RUN apt-get update
RUN apt-get -y --force-yes install wget

# Install Go
RUN \
  mkdir -p /goroot && \
  curl https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1

# Set environment variables.
ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH

# Install gpm
RUN wget https://raw.githubusercontent.com/pote/gpm/v1.3.2/bin/gpm && chmod +x gpm && mv gpm /usr/local/bin

#Install mercurial
RUN apt-get -y --force-yes install mercurial

# Install git
RUN apt-get -y --force-yes install git

RUN go get "github.com/kelseyhightower/envconfig"
RUN go get "github.com/therealbill/airbrake-go"
RUN go get "github.com/therealbill/libredis/client"
RUN go get "github.com/therealbill/libredis/info"
RUN go get "github.com/zenazn/goji"
RUN go get github.com/therealbill/redskull

WORKDIR /gopath/src/github.com/therealbill/redskull/
ADD . /gopath/src/github.com/therealbill/redskull/

# Create sentinel.conf
RUN \
    cd /etc && \
    mkdir redis && \
    cd redis && \
    curl http://download.redis.io/redis-stable/sentinel.conf | sed '/mymaster/d' > sentinel.conf

# Install Red Skull
RUN \
    cd /gopath/src/github.com/therealbill/redskull/ && \
		gpm install

RUN go get
RUN go build

# Need to run ./redskull manually after set Sentinel configuration using redis-cli

ENTRYPOINT ["redis-sentinel", "/etc/redis/sentinel.conf"]
