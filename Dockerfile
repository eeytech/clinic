=========================
Etapa 1 - Build
=========================
FROM node:18-alpine AS builder

Diretório de trabalho
WORKDIR /app

Copia arquivos de dependências
COPY package.json package-lock.json* yarn.lock* pnpm-lock.yaml* ./

Instala dependências
RUN \
  if [ -f yarn.lock ]; then yarn install --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then npm install -g pnpm && pnpm install; \
  else npm install; \
  fi

Copia o restante do projeto
COPY . .

Build do Next.js
RUN npm run build  yarn build 
 pnpm build


=========================
Etapa 2 - Runtime
=========================
FROM node:18-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV PORT=80

Copia apenas o necessário para produção
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/next.config.js* ./

Expõe a porta usada pelo CapRover
EXPOSE 80

Inicia o Next.js na porta 80
CMD ["npm", "start"]