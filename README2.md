Combining a backend and frontend Dockerfile into a single Dockerfile can streamline the build process. Below is a basic example assuming your backend is a Node.js application and your frontend is a React app.

### Sample Directory Structure
```
/project
│
├── /backend
│   ├── Dockerfile
│   ├── package.json
│   └── ...
│
├── /frontend
│   ├── Dockerfile
│   ├── package.json
│   └── ...
│
└── docker-compose.yml
```

### Combined Dockerfile
Here’s how you could combine both into one Dockerfile located at the root of the project.

```Dockerfile
# Stage 1: Build Frontend
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

EXPOSE 3000
CMD ["node", "server.js"]  # Adjust this command to start your backend
```

### Explanation
1. **Stage 1**: Build the frontend app. It installs dependencies and runs the build command, producing static files.
2. **Stage 2**: Set up the backend app by installing its dependencies.
3. **Stage 3**: Create the final image, copying the built frontend files into the backend's public directory.

### Build the Image
You can build this image using:

```bash
docker build -t my-app .
```

### Running the Container
If you need to run the container, you can use:

```bash
docker run -p 3000:3000 my-app
```

### Considerations
- Adjust paths, node versions, and commands according to your specific app.
- If your backend serves the frontend, ensure the static files are correctly placed.
- For production, consider using multi-stage builds for optimization.
