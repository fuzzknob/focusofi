FROM dart:stable AS build

RUN apt update && apt-get install sqlite3 -y

RUN set -eux; \
    case "$(dpkg --print-architecture)" in \
    amd64) \
    ARCH="x86_64-linux-gnu";; \
    armhf) \
    ARCH="arm-linux-gnueabihf";; \
    arm64) \
    ARCH="aarch64-linux-gnu";; \
    *) \
    echo "Unsupported architecture" ; \
    exit 5;; \
    esac; \
    cp /usr/lib/$ARCH/libsqlite3.so.0.8.6 /runtime/lib/$ARCH/libsqlite3.so

WORKDIR /app

COPY pubspec.* ./

RUN dart pub get

COPY . .

RUN dart pub get --offline

RUN dart compile exe bin/pomo_server.dart -o bin/pomo_server

FROM scratch

COPY --from=build /runtime /

COPY --from=build /app/db /app/db
COPY --from=build /app/assets /assets
COPY --from=build /app/bin/pomo_server /app/bin/

EXPOSE 8000

ENTRYPOINT ["/app/bin/pomo_server"]

CMD ["migrate-start"]
