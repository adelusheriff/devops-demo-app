# --- Build stage: install deps with dev dependencies available for tests ---
FROM node:20-alpine AS build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .

# --- Runtime stage: only production deps, smaller final image ---
FROM node:20-alpine AS runtime
WORKDIR /usr/src/app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm install --omit=dev && npm cache clean --force

COPY --from=build /usr/src/app/src ./src
COPY --from=build /usr/src/app/public ./public

# Run as a non-root user (security best practice, and avoids the classic
# "container runs as root" finding in any infra review)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "src/index.js"]
