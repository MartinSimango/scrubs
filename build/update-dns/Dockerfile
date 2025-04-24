FROM amazon/aws-cli:latest
WORKDIR /app
COPY scripts/update-dns.sh /app/update-dns.sh
RUN chmod +x /app/update-dns.sh
ENTRYPOINT ["./update-dns.sh"]


