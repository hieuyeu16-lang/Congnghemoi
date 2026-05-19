FROM node:18-alpine AS frontend-build
WORKDIR /frontend
COPY frontend/package.json frontend/package-lock.json* ./
RUN npm install
COPY frontend ./
RUN npm run build

FROM node:18-alpine AS backend
WORKDIR /app
COPY backend/package.json backend/package-lock.json* ./
RUN npm install --production
COPY backend/src ./src
COPY backend/.env.example ./
COPY --from=frontend-build /frontend/dist ./dist
ENV NODE_ENV=production
EXPOSE 4000
CMD ["node", "src/index.js"]
