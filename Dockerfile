FROM node:20-alpine AS build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .

FROM node:20-alpine AS runtime
WORKDIR /usr/src/app
ENV NODE_ENV=production

RUN apk update && apk upgrade --no-cache

COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force \
  && rm -rf /usr/local/lib/node_modules/npm \
            /usr/local/lib/node_modules/corepack \
            /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack

COPY --from=build /usr/src/app/src ./src
COPY --from=build /usr/src/app/public ./public

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "src/index.js"]
