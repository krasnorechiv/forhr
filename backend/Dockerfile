FROM golang:1.24.2-bookworm as builder
WORKDIR /usr/app
RUN echo "Building ${APP_NAME} ${VERSION} from ${URL} ${CRED_NEXUS}"

RUN curl -O -u $CRED_NEXUS $URL/${APP_NAME} && chmod +x ${APP_NAME}

FROM golang:1.24.2-bookworm
WORKDIR /app
RUN addgroup --system gouser \
    && adduser --system --shell /bin/false --group gouser --disabled-login
COPY --chown=gouser:gouser \
     --from=builder /usr/app/${APP_NAME} ./pelmennaya
HEALTHCHECK CMD code=$(curl http://localhost:8081/health -v 2>&1 | awk '/^< HTTP/{print $3}'); if [ "$code" -ne "200" ]; then exit 1; fi
EXPOSE 8081
USER gouser
ENTRYPOINT ["./pelmennaya"] 