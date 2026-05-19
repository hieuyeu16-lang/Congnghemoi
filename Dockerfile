FROM node:18-alpine AS base
WORKDIR /app

# Copy backend manifest and install production deps
COPY backend/package.json backend/package-lock.json* ./
RUN npm install --production

# Copy backend source code
COPY backend/src ./src
COPY backend/.env.example ./

ENV NODE_ENV=production
EXPOSE 4000
CMD ["node", "src/index.js"]
