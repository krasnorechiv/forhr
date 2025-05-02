FROM debian:bookworm as builder
ARG CRED_NEXUS=${CRED_NEXUS} \
    URL_TO_DOWNLOAD=${URL_TO_DOWNLOAD} \
    APP_NAME=${APP_NAME}
WORKDIR /usr/src/app
RUN apt update && apt install -y curl tar \
    && curl -O -u ${CRED_NEXUS} ${URL_TO_DOWNLOAD}/${APP_NAME}.tar.gz \
    && tar -xzvf ${APP_NAME}.tar.gz


FROM debian:bookworm
WORKDIR /app/frontend
RUN apt update && apt install -y nginx
COPY ./nginx/default.conf /etc/nginx/sites-available/default
COPY --from=builder --chown=www-data:www-data /usr/src/app/frontend/dist/ .
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]