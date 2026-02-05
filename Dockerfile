# Imagem base necessária
FROM node:20

# Diretório de trabalho
WORKDIR /var/www/html/

# Copiar pacotes e instalar dependências
COPY package.json package-lock.json* ./
RUN npm install

# Copiar o restante do projeto
COPY . .

# Build do Next.js
ARG DATABASE_URL="postgresql://neondb_owner:npg_m78DlbotFUCq@ep-proud-grass-ac4p4r24-pooler.sa-east-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require"
ENV DATABASE_URL=$DATABASE_URL
RUN npm run build

# Expõe a porta padrão
EXPOSE 80

# Comando de start
CMD ["npm", "start"]