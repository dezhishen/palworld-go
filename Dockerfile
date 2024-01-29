FROM golang:alpine as builder
WORKDIR /build
RUN apk add --no-cache upx 
COPY . .
RUN go build -ldflags="-s -w" -o /palworld-go-webui cmd/main.go && \
    upx --lzma /palworld-go-webui

FROM alpine
LABEL maintainer="github.com/dezhishen/palworld-go-webui"
EXPOSE 8080/tcp
WORKDIR /data
VOLUME /data
COPY --from=builder /palworld-go-webui /palworld-go-webui
RUN chmod +x /palworld-go-webui
ENTRYPOINT [ "/palworld-go-webui" ]