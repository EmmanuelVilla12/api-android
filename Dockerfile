# syntax=docker/dockerfile:1

# ---- Dependencias de producción ----
FROM node:22-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

# ---- Imagen final ----
FROM node:22-alpine
ENV NODE_ENV=production
WORKDIR /app

COPY --from=deps --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node package.json ./
COPY --chown=node:node src ./src

# Render inyecta PORT (por defecto 10000); la app lo lee de process.env.PORT
ENV PORT=10000
EXPOSE 10000

USER node
CMD ["node", "src/server.js"]
