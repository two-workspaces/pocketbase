# PocketBase from the official release zip. pb_migrations/ and pb_hooks/ are
# baked into the image: drop your own JS migrations and hooks in there in a fork.
FROM alpine:3.22
# upgrade: github pocketbase/pocketbase
ARG PB_VERSION=0.40.6
RUN apk add --no-cache ca-certificates \
 && wget -qO /tmp/pb.zip https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip \
 && unzip /tmp/pb.zip pocketbase -d /pb && rm /tmp/pb.zip
COPY pb_migrations /pb/pb_migrations
COPY pb_hooks /pb/pb_hooks
EXPOSE 8090
CMD ["/pb/pocketbase", "serve", "--http=[::]:8090", "--dir=/pb_data", "--migrationsDir=/pb/pb_migrations", "--hooksDir=/pb/pb_hooks", "--encryptionEnv=PB_ENCRYPTION_KEY"]
