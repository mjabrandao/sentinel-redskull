FROM redis:latest

RUN \
	apt-get update && \
	apt-get install wget && \
	wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.4.2.linux-amd64.tar.gz && \
	echo "export PATH=$PATH:/usr/local/bin" >> /root/.bashrc && \
	echo "export PATH=$PATH:/usr/local/go/bin" >> /root/.bashrc && \
	echo "export GOPATH=/usr/local/go/bin" >> /root/.bashrc && \
	wget https://raw.githubusercontent.com/pote/gpm/v1.3.2/bin/gpm && chmod +x gpm && mv gpm /usr/local/bin && \
	apt-get install mercurial && \
	apt-get install git && \
	go get "github.com/kelseyhightower/envconfig" && \
	go get "github.com/therealbill/airbrake-go" && \
	go get "github.com/therealbill/libredis/client" && \
	go get "github.com/therealbill/libredis/info" && \
	go get "github.com/zenazn/goji" && \
	go get github.com/therealbill/redskull && \
	cd $GOPATH/src/github.com/therealbill/redskull && \
	gpm install && \
	go build && \
	./redskull && \
	cd /etc && \
	mkdir redis && \
	cd redis && \
	curl -o - http://download.redis.io/redis-stable/sentinel.conf | sed '/mymaster/d' > sentinel.conf

ENTRYPOINT ["redis-sentinel", "/etc/redis/sentinel.conf"]
EXPOSE 26379
# Red Skull
EXPOSE 8000:8000
