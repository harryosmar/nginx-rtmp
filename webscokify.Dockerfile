FROM buildpack-deps:bullseye

# Install dependencies
RUN apt-get update && \
    apt-get install -y ca-certificates openssl libssl-dev websockify && \
    rm -rf /var/lib/apt/lists/*


EXPOSE 9001
CMD ["websockify", "9001", "rtmp:1935"]