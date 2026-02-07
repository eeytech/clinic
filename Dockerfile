# 1. Estágio de Build - Adicionamos "AS builder" aqui para o Docker reconhecer o nome
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install --legacy-peer-deps
COPY . .

# Argumentos de build para o Next.js (se necessário no momento do build)
ARG DATABASE_URL
ENV DATABASE_URL=$DATABASE_URL

RUN npm run build

# 2. Estágio de Runner
FROM node:20-slim AS runner
WORKDIR /app
ENV NODE_ENV production

# Agora o --from=builder vai funcionar corretamente
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/drizzle ./drizzle 
# (Certifique-se de copiar a pasta onde estão seus schemas/migrations do drizzle)

EXPOSE 3000

# Usamos um único CMD que executa a migração antes de iniciar o app
CMD npx drizzle-kit push && npm start