FROM golang:alpine as server-builder
# add build dependencies
RUN apk add --no-cache gcc musl-dev upx
# create dir
RUN mkdir /app 
WORKDIR /app 
# Copy the files
COPY server/* ./
# build the binary
RUN go build -o jon4hzio -ldflags="-s" -tags netgo .
# compress the binary
RUN upx -9 -k jon4hzio

######################################################################
# compile the hugo website
FROM alpine as web-builder
# add build dependencies
RUN apk add --no-cache curl
# create dir
RUN mkdir /app
WORKDIR /app
# Copy files
COPY ./website/ .
# install hugo
COPY hugo-install.sh .
RUN ./hugo-install.sh
# execute hugo
RUN ./hugo
######################################################################
# runtime container
FROM scratch
COPY --from=server-builder /app/jon4hzio ./server/jon4hzio
#COPY ./website/public ./website/public
COPY --from=web-builder /app/public ./website/public
EXPOSE 3000
ENTRYPOINT [ "./server/jon4hzio" ]