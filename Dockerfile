FROM node:20.9.0 as front-builder
WORKDIR /build
RUN npm install -g @quasar/cli
COPY . .
RUN cd front/palworld-front && npm install && quasar build
FROM golang:1.21.1-alpine as builder
WORKDIR /build
RUN apk add --no-cache upx
COPY . .
COPY --from=front-builder /build/webui/dist /build/webui/dist
RUN cd /build && \
go build -ldflags="-s -w" -o /palworld-go-webui && \
upx /palworld-go-webui
FROM alpine
LABEL maintainer="github.com/dezhishen/palworld-go-webui"
EXPOSE 52000/tcp
WORKDIR /data
VOLUME /data
COPY --from=builder /palworld-go-webui /palworld-go-webui
RUN chmod +x /palworld-go-webui
ENTRYPOINT [ "/palworld-go-webui" ]