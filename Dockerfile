FROM alpine:latest

#install necessary packages
RUN apk update; \
    apk upgrade; \
    apk add fetchmail openssl logrotate;

#set workdir
WORKDIR /data

#setup fetchmail stuff, fetchmail user is created by installing the fetchmail package
RUN chown fetchmail:fetchmail /data; \
    chmod 0744 /data; 

#add logrotate fetchmail config
ADD etc/logrotate.d/fetchmail /etc/logrotate.d/fetchmail
#add startup script
ADD start.sh /bin/start.sh
#add fetchmail_daemon script
ADD fetchmail_daemon.sh /bin/fetchmail_daemon.sh
#copy sample config
COPY fetchmailrc /data/etc/sample/fetchmailrc.sample

#set startup script rights
RUN chmod 0700 /bin/start.sh; \
    chown fetchmail:fetchmail /bin/fetchmail_daemon.sh

VOLUME ["/data"]
CMD ["/bin/sh", "/bin/start.sh"]

