# Stage 1: Build
FROM node:latest AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2: Runtime
FROM node:latest
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
USER node
EXPOSE 8080
ENV NODE_ENV=production
CMD ["node", "server.js"]
