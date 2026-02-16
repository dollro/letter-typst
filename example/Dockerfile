FROM docker.io/rust:slim-trixie AS builder
ARG TYPST_VERSION=v0.14.2

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    git pkg-config libssl-dev

WORKDIR /typst

RUN git clone -c advice.detachedHead=false \
    --branch $TYPST_VERSION --single-branch --depth 1 \
    https://github.com/typst/typst.git ./

RUN CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse \
    cargo build -p typst-cli --release

# --- Fetch letter-typst package (release tarball or git clone) ---
FROM alpine AS letter-pkg
ARG LETTER_TYPST_GL_BRANCH=main
ARG LETTER_TYPST_GL_HOST=gitlab.example.com
ARG LETTER_TYPST_GL_PROJECT=namespace/letter-typst
ARG LETTER_TYPST_NAME=letter-typst
ARG LETTER_TYPST_VERSION=
RUN apk add --no-cache git curl
RUN --mount=type=secret,id=LETTER_TYPST_GL_TOKEN \
    TOKEN=$(cat /run/secrets/LETTER_TYPST_GL_TOKEN 2>/dev/null || true) && \
    if [ -n "$LETTER_TYPST_VERSION" ] && [ -n "$TOKEN" ]; then \
        GL_PROJECT_ENCODED=$(echo "$LETTER_TYPST_GL_PROJECT" | sed 's/\//%2F/g') && \
        curl -fSL -H "PRIVATE-TOKEN: $TOKEN" \
            "https://$LETTER_TYPST_GL_HOST/api/v4/projects/$GL_PROJECT_ENCODED/repository/archive.tar.gz?sha=$LETTER_TYPST_VERSION" \
            -o /tmp/pkg.tar.gz && \
        mkdir -p /install/typst/packages/local/$LETTER_TYPST_NAME/$LETTER_TYPST_VERSION && \
        tar xzf /tmp/pkg.tar.gz --strip-components=1 -C /install/typst/packages/local/$LETTER_TYPST_NAME/$LETTER_TYPST_VERSION; \
    elif [ -n "$TOKEN" ]; then \
        git clone --depth 1 --branch "$LETTER_TYPST_GL_BRANCH" \
            "https://$LETTER_TYPST_NAME:$TOKEN@$LETTER_TYPST_GL_HOST/$LETTER_TYPST_GL_PROJECT.git" /tmp/package && \
        rm -rf /tmp/package/.git && \
        PKG_VERSION=$(grep '^version' /tmp/package/typst.toml | sed 's/.*"\(.*\)"/\1/') && \
        mkdir -p /install/typst/packages/local/$LETTER_TYPST_NAME/$PKG_VERSION && \
        cp -a /tmp/package/. /install/typst/packages/local/$LETTER_TYPST_NAME/$PKG_VERSION/; \
    else \
        echo "No GL token — skipping remote fetch (package provided via volume mount)"; \
        mkdir -p /install; \
    fi

FROM docker.io/debian:trixie-slim

COPY --from=builder /typst/target/release/typst /usr/bin/typst

WORKDIR /root

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates fontconfig

# Copy custom fonts into the image
COPY fonts/ /usr/share/fonts/custom/
RUN fc-cache -f -v

# Install letter-typst Typst package (may be empty if no remote fetch;
# docker-compose volume mount provides the package at runtime)
COPY --from=letter-pkg /install/ /opt/typst-data/
ENV XDG_DATA_HOME=/opt/typst-data
