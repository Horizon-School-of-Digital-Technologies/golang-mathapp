# Dockerfile.production

FROM golang:1.22-alpine3.20 as builder

ENV APP_HOME /go/src/mathapp

WORKDIR "$APP_HOME"
COPY src/ .

RUN go mod download
RUN go mod verify
RUN CGO_ENABLED=0 go build -o mathapp

FROM gcr.io/distroless/static-debian11 as prod

ENV APP_HOME /go/src/mathapp
WORKDIR "$APP_HOME"

COPY src/conf/ conf/
COPY src/views/ views/
COPY --from=builder "$APP_HOME"/mathapp $APP_HOME

EXPOSE 8010
CMD ["./mathapp"]