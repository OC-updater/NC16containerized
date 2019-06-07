#FROM debian:stretch-slim
FROM debian:stretch AS runner

RUN apt update \
 && apt -y install curl gnupg2 ca-certificates lsb-release \
 && echo "deb http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list \
 && curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
 && apt update \
 && apt -y install nginx

COPY nginx.conf /etc/nginx/


#  Some addinal debug tools are added
RUN echo "starting to install some useful monitoring tools" \
 && apt update \
 && apt -y install procps net-tools \
 && echo "Finished extra install"


