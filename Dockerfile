FROM ghcr.io/lloesche/valheim-server

# install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -rf ./aws*

ADD backup.sh /
ADD backup-cron /etc/cron.d/backup-cron

RUN crontab /etc/cron.d/backup-cron

ADD bootstrap.sh /

CMD ["/bootstrap.sh"]