FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY prisma ./prisma
COPY src ./src
COPY tsconfig.json nest-cli.json ./
RUN ./node_modules/.bin/nest build

FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
RUN ./node_modules/.bin/prisma generate
EXPOSE 3001
CMD ["node", "dist/main"]
