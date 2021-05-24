FROM golang:alpine as builder
# add build dependencies
RUN apk add --no-cache gcc musl-dev upx

RUN mkdir /app 
ADD server/* /app/
WORKDIR /app 
# build the binary
RUN go build -o jon4hzio -ldflags="-s" -tags netgo .
# compress the binary
RUN upx -9 -k jon4hzio

FROM scratch
COPY --from=builder /app/jon4hzio ./server/jon4hzio
COPY ./website/public ./website/public
EXPOSE 3000
ENTRYPOINT [ "./server/jon4hzio" ]