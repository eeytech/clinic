Diretório de trabalho
WORKDIR /var/www/html/

Copiar pacotes e instalar dependências
COPY package.json package-lock.json* ./
RUN npm install

Copiar o restante do projeto
COPY . .

Build do Next.js
RUN npm run build

Expõe a porta padrão
EXPOSE 80

Comando de start
CMD ["npm", "start"]