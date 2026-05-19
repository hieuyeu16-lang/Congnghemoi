FROM node:18-alpine AS base
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm install --production
COPY src ./src
COPY .env.example ./

ENV NODE_ENV=production
EXPOSE 4000
CMD ["node", "src/index.js"]
