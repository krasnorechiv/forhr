FROM debian:bookworm as builder
ARG CRED_NEXUS=${CRED_NEXUS} \
    URL_TO_DOWNLOAD=${URL_TO_DOWNLOAD} \
    APP_NAME=${APP_NAME}
WORKDIR /usr/src/app
RUN curl -O -u ${CRED_NEXUS} ${URL_TO_DOWNLOAD}/${APP_NAME}.tar.gz \
    && tar -xzvf ${APP_NAME}.tar.gz


FROM nginx:1.27.5-alpine
WORKDIR /app/frontend
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/src/app/frontend/dist/ .
EXPOSE 80