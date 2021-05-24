FROM golang:alpine as builder
RUN mkdir /app 
ADD . /app/
WORKDIR /app 
# add build dependencies
RUN apk add --no-cache gcc musl-dev upx
# build the binary
RUN go build -o jon4hzio -ldflags="-s" -tags netgo .
# compress the binary
RUN upx -9 -k jon4hzio

FROM scratch
COPY --from=builder /app/jon4hzio .
COPY --from=builder /app/public ./public
EXPOSE 3000
ENTRYPOINT [ "./jon4hzio" ]