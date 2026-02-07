# 1. Estágio de Build
FROM node:20 AS builder
WORKDIR /app

# Instala dependências
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Copia o restante dos arquivos
COPY . .

# Argumento para o DATABASE_URL (usar valor dummy para o build)
ARG DATABASE_URL="postgresql://postgres:postgres@localhost:5432/postgres"
ENV DATABASE_URL=$DATABASE_URL

# Executa o build do Next.js
RUN npm run build

# 2. Estágio de Runner (Produção)
FROM node:20-slim AS runner
WORKDIR /app
ENV NODE_ENV production

# Copia apenas o necessário do estágio builder
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Copia os arquivos necessários para o Drizzle (Baseado na sua estrutura)
COPY --from=builder /app/drizzle.config.ts ./
COPY --from=builder /app/src/db ./src/db

EXPOSE 3000

# Executa as migrações e inicia o servidor
CMD npx drizzle-kit push && npm start