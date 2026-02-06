# Imagem base necessária
FROM node:20

# Diretório de trabalho
WORKDIR /var/www/html/

# Copiar pacotes e instalar dependências
COPY package.json package-lock.json* ./
RUN npm install --legacy-peer-deps

# Copiar o restante do projeto
COPY . .

# Build do Next.js
ARG DATABASE_URL="teste"
ENV DATABASE_URL=$DATABASE_URL
RUN npm run build

# Expõe a porta padrão
EXPOSE 80

# Comando de start
CMD ["npm", "start"]