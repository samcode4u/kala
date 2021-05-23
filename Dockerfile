FROM golang:1.16.3-alpine as builder
WORKDIR /go/src/github.com/samcode4u/kala
COPY . .
RUN apk update
RUN apk upgrade
RUN apk add --update gcc g++
RUN GOOS=linux go build -a -installsuffix cgo -o app .


FROM alpine:latest
RUN apk --no-cache add ca-certificates curl libxml2
WORKDIR /
COPY --from=builder /go/src/github.com/samcode4u/kala/app .
EXPOSE 8000
# kala serve --jobdb=redis --jobdb-address=127.0.0.1:6379
CMD ["/app","serve","--jobdb=redis","--jobdb-address=redis:6379"]
