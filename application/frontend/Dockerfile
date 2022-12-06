
FROM node:16.17.1-alpine as build-stage

WORKDIR /app

# copy packages + env files
COPY package*.json ./

# install project depencies
RUN npm install && npm audit fix --force

COPY src ./src
COPY public ./public

COPY index.html .
COPY tsconfig.json .
COPY tsconfig.node.json .

COPY vite.config.ts .

EXPOSE 8080

RUN npm run dev --host 0.0.0.0 --port 80
