FROM alpine

RUN apk --no-cache add autoconf automake pkgconf gengetopt jansson-dev openssl-dev libsrtp-dev libcurl glib-dev opus-dev libogg-dev libtool gcc make g++ zlib-dev libconfig-dev libnice-dev libmicrohttpd-dev libwebsockets-dev \
    # Complie janus
    && wget https://github.com/meetecho/janus-gateway/archive/master.zip \
    && unzip master.zip \
    && cd janus-gateway-master \
    && sh autogen.sh \
    && ./configure --prefix=/opt/janus \
    && make && make install && make configs \
    # clean Complie component
    && cd .. \
    && rm -rf master.zip janus-gateway-master \
    && apk del autoconf automake pkgconf gengetopt jansson-dev openssl-dev libsrtp-dev libcurl glib-dev opus-dev libogg-dev libtool gcc make g++ zlib-dev libconfig-dev libnice-dev libmicrohttpd-dev libwebsockets-dev

# Install runtime env
RUN apk --no-cache add libconfig libnice glib jansson libsrtp opus libogg libmicrohttpd libwebsockets

# Expose Web server HTTP port & WebSockets server port
EXPOSE 8088 8188

CMD /opt/janus/bin/janus
