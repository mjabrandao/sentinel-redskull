FROM redis:latest

RUN \
	apt-get update && \
	apt-get install wget && \
	wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.4.2.linux-amd64.tar.gz && \
	echo "export PATH=$PATH:/usr/local/bin" > ~/.bashrc && \
	echo "export PATH=$PATH:/usr/local/go/bin" > ~/.bashrc && \
	echo "export GOPATH=/usr/local/go/bin" > ~/.bashrc && \
	cd /etc && \
	mkdir redis && \
	cd redis && \
	curl -o - http://download.redis.io/redis-stable/sentinel.conf | sed '/mymaster/d' > sentinel.conf

ENTRYPOINT ["redis-sentinel", "/etc/redis/sentinel.conf"]
EXPOSE 26379
# Red Skull
EXPOSE 8000:8000
