FROM httpd:2

RUN htpasswd -Bbn admin ctfo@123 > /tmp/htpasswd

FROM registry:2

RUN mkdir /auth

COPY --from=0 /tmp/htpasswd /auth

ENV REGISTRY_AUTH=htpasswd \
	REGISTRY_AUTH_HTPASSWD_REALM="Registry Realm" \
	REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd
