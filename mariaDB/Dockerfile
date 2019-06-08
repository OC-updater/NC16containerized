#FROM debian:stretch-slim
FROM debian:stretch AS runner

# --- Install nginx
RUN apt update \
 && apt -y install apt-transport-https curl gnupg2 ca-certificates lsb-release \
 && echo "deb [arch=amd64] http://mirror.klaus-uwe.me/mariadb/repo/10.3/debian $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/mariadb.list \
 && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xF1656F24C74CD1D8 \
 && apt update \
 && apt -y install mariadb-server

RUN echo "starting to install some useful monitoring tools" \
 && apt update \
 && apt -y install procps net-tools socat less \
 && apt -y install mariadb-client \
 && echo "Finished extra install"


VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
#ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
#CMD ["mysqld"]
