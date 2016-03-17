FROM alpine:latest

MAINTAINER Rob Van Mieghem <robvanmieghem@gmail.com>

# Small utility docker that runs an sshd to easily access other containers
# Pass a public key as commandparameter, it will be added to the authorized keys of the root user


RUN apk update && \
    apk add bash git openssh rsync && \
    rm -rf /var/cache/apk/*

EXPOSE 22

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]
