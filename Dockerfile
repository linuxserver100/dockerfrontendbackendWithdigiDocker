FROM node:14 AS frontend-build

WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Build Backend
FROM node:14 AS backend-build

WORKDIR /app/backend
COPY backend/package.json backend/package-lock.json ./
RUN npm install
COPY backend/ ./

# Stage 3: Final image
FROM node:14

# Copy built frontend files from frontend-build stage
COPY --from=frontend-build /app/frontend/build /app/backend/public

WORKDIR /app/backend
COPY --from=backend-build /app/backend .

EXPOSE 3001
CMD ["npm", "start"]  # Adjust this command to start your backend
