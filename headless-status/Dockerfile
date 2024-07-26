FROM alpine:latest AS base

ARG HOSTUSERID
ARG HOSTGROUPID

# Install node and npm
RUN apk add --no-cache nodejs npm

# Upgrade npm and install yarn
RUN npm install --no-update-notifier --no-audit --no-fund --omit=dev -g npm

RUN mkdir -p /usr/src/node-red /data && \
    addgroup -g ${HOSTGROUPID} node-red && \
    adduser -h /usr/src/node-red -D -H node-red -u ${HOSTUSERID} -G node-red && \
    adduser node-red dialout && \
    adduser node-red audio && \
    chown -R node-red:node-red /data && chmod -R g+rwX /data && \
    chown -R node-red:node-red /usr/src/node-red && chmod -R g+rwX /usr/src/node-red

# Set work directory
WORKDIR /usr/src/node-red

USER node-red

# Env variables
ENV NODE_RED_VERSION=$NODE_RED_VERSION \
    NODE_PATH=/usr/src/node-red/node_modules:/data/node_modules \
    PATH=/usr/src/node-red/node_modules/.bin:${PATH} \
    FLOWS=flows.json

# ENV NODE_RED_ENABLE_SAFE_MODE=true    # Uncomment to enable safe start mode (flows not running)
# ENV NODE_RED_ENABLE_PROJECTS=true     # Uncomment to enable projects option

# package.json contains Node-RED NPM module and node dependencies
COPY --chown=node-red:node-red package.json .

# Copy Node-RED project files
COPY settings.js /data/settings.js
COPY flows.json /data/flows.json

# Install node and dependencies
RUN npm install --unsafe-perm --no-update-notifier --no-audit --no-fund --omit=dev

# Expose the listening port of node-red
# EXPOSE 1880/tcp

ENTRYPOINT ["npm", "--no-update-notifier", "--no-fund", "start", "--cache", "/data/.npm", "--", "--userDir", "/data"]
