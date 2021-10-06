FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    nmap \
    netcat \
    bind9-host \
    dnsutils \
    tcptraceroute \
    postgresql-client

RUN apt-get autoclean
