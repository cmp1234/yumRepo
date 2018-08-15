FROM  centos

ENV NGINX_VERSION 1.15.2
ENV BLUID_LIST  "gcc cpp glibc-devel glibc-headers kernel-headers libgomp libmpc mpfr make"

RUN adduser -u 18345 cmp \
    && yum install -y ${BLUID_LIST} \
    && yum install -y createrepo net-tools \
    && mkdir /opt/tmp \
    && curl -kLo /opt/tmp/nginx.tgz https://github.com/nginx/nginx/archive/release-${NGINX_VERSION}.tar.gz \
    && tar -zxf /opt/tmp/nginx.tgz -C /opt/tmp/ \
    && cd /opt/tmp/nginx-release-${NGINX_VERSION} \
    && auto/configure --without-http_rewrite_module --without-http_gzip_module \
    && make && make install \
    && ln -sf /dev/stdout /usr/local/nginx/logs/access.log \
    && ln -sf /dev/stderr /usr/local/nginx/logs/error.log \
    && ln -sf /usr/local/nginx/sbin/nginx /usr/bin/nginx \
    && yum clean all \
    && rm -rf /var/cache/yum/ /opt/tmp \

USER cmp
WORKDIR /home/cmp

COPY --chown=cmp docker-entrypoint.sh /usr/bin/
COPY --chown=cmp nginx.conf /usr/local/nginx/conf/nginx.conf
RUN chmod 0700 /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
