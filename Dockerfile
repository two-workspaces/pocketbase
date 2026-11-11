# PocketBase from the official release zip. pb_migrations/ and pb_hooks/ are
# baked into the image: drop your own JS migrations and hooks in there in a fork.
FROM alpine:3.24
# PocketBase moved off GitHub in Oct 2026 (pocketbase/pocketbase#7872); releases
# are only published at ganigeorgiev.com/pocketbase now. Bump both together:
# the checksum is from that release's checksums.txt.
# upgrade: bugstage ganigeorgiev.com/pocketbase/pocketbase
ARG PB_VERSION=0.42.0
ARG PB_SHA256=cd3439e7740e9b82e4ee947130ff3d1e7a66ef8d8bd219308fc1fa7b38bfdacc
RUN apk add --no-cache ca-certificates \
 && wget -qO /tmp/pb.zip https://ganigeorgiev.com/meta/pocketbase/pocketbase/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip \
 && echo "${PB_SHA256}  /tmp/pb.zip" | sha256sum -c - \
 && unzip /tmp/pb.zip pocketbase -d /pb && rm /tmp/pb.zip
COPY pb_migrations /pb/pb_migrations
COPY pb_hooks /pb/pb_hooks
EXPOSE 8090
CMD ["/pb/pocketbase", "serve", "--http=[::]:8090", "--dir=/pb_data", "--migrationsDir=/pb/pb_migrations", "--hooksDir=/pb/pb_hooks", "--encryptionEnv=PB_ENCRYPTION_KEY"]
