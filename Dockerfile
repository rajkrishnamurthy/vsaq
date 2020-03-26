FROM python:2.7.17-slim-stretch as builder
LABEL Author="raj.krishnamurthy@continube.com"

ADD . /  /root/vsaq/
 
WORKDIR /root/vsaq/
RUN chmod +x do.sh && \
    chmod +x download-libs.sh
RUN apt-get update && \
    apt-get install -y unzip git wget maven ant curl && \
    apt-get install -y default-jdk 
RUN ./do.sh install_deps && \
    ./do.sh build

FROM python:2.7.17-alpine3.11
RUN apk --no-cache add ca-certificates
RUN mkdir -p /continube/vsaq
WORKDIR /continube/vsaq
COPY --from=builder /root/vsaq/ .
CMD ["/bin/sh","-c","do.sh","run"]
