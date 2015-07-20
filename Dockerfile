FROM redis:latest

RUN \
	apt-get update \
	apt-get install wget \
	echo "export PATH=$PATH:/usr/local/bin" > ~/.bashrc \
	export PATH=$PATH:/usr/local/go/bin \
	export GOPATH=/usr/local/go/bin \
	cd /etc && \
	mkdir redis && \
	cd redis && \
	curl -o - http://download.redis.io/redis-stable/sentinel.conf | sed '/mymaster/d' > sentinel.conf
	
ENTRYPOINT ["redis-sentinel", "/etc/redis/sentinel.conf"]
EXPOSE 26379
# Red Skull
EXPOSE 8000:8000
