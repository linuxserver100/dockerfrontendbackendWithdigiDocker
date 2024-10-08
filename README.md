A demonstration of Docker to implement a simple 3 tier architecture

* frontend will be able to access the mid-tier
* mid-tier will be able to access the db

In order to run this in docker, simply type ```docker-compose up``` at the command prompt. Docker will then create the [MongoDB](https://www.mongodb.com/) from the stock [mongo](https://hub.docker.com/_/mongo) image. The api uses [nodejs](https://nodejs.org/) with [express](http://expressjs.com/) and is built from a [node:alpine](https://hub.docker.com/_/node) image. The front end uses [ReactJS](https://reactjs.org/) and built from a [node:alpine](https://hub.docker.com/_/node) image.






Here's a GitHub Actions workflow that builds both the frontend (React app) and backend (Node.js/Express app) of your application, then pushes the combined image to the DigitalOcean Container Registry.


prequesties#######

1.Docker file of frontend 
2.Dockerfile of backend

in below steps we combine both docker files in a third docker file which will be present in the root directory of the application and the create a ci.yml file in workflows to execute both backend and frontend in one image and then push it of container registry on digitalocean 

### GitHub Actions Workflow

Create a file named `ci.yml` in the `.github/workflows` directory of your repository and add the following code:

```yaml
name: Build and Push Combined Image

on:
  push:
    branches:
      - main  # Change this to your main branch if different

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v1

      - name: Log in to DigitalOcean Container Registry
        uses: docker/login-action@v1
        with:
          registry: registry.digitalocean.com
          username: ${{ secrets.DIGITALOCEAN_USERNAME }}
          password: ${{ secrets.DIGITALOCEAN_ACCESS_TOKEN }}

      - name: Build Docker image
        run: |
          docker build -t registry.digitalocean.com/your-digitalocean-username/your-app-name:latest .

      - name: Push Docker image
        run: |
          docker push registry.digitalocean.com/your-digitalocean-username/your-app-name:latest
```

### Explanation:
1. **Triggers:** The workflow is triggered on pushes to the `main` branch.
2. **Jobs:**
   - **Checkout:** Retrieves your repository code.
   - **Docker Buildx:** Sets up Docker Buildx for building multi-platform images (if needed).
   - **Login:** Authenticates with the DigitalOcean Container Registry using GitHub secrets.
   - **Build Docker Image:** Builds the Docker image from the `Dockerfile` in the root of your project.
   - **Push Docker Image:** Pushes the built image to the DigitalOcean Container Registry.

### Setup Secrets:
In your GitHub repository, navigate to **Settings > Secrets and variables > Actions** and add the following secrets:
- `DIGITALOCEAN_USERNAME`: Your DigitalOcean username.
- `DIGITALOCEAN_ACCESS_TOKEN`: A personal access token with read/write permissions for your container registry.

### Dockerfile Example

Make sure you have a `Dockerfile` in the root of your project that combines the frontend and backend. Here’s an example:

```dockerfile
# Stage 1: Build Frontend
FROM node:16 AS frontend-build

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend/ .
RUN npm run build

# Stage 2: Build Backend
FROM node:16 AS backend-build

WORKDIR /app/backend

COPY backend/package*.json ./
RUN npm install

COPY backend/ .

# Copy built frontend files to backend
COPY --from=frontend-build /app/frontend/build ./public

EXPOSE 3000

CMD ["node", "server.js"]  # Adjust this as necessary for your main server file
```

### Final Notes:
- Replace `your-digitalocean-username` and `your-app-name` with your actual DigitalOcean username and the name you want for your application in the container registry.
- Ensure your backend is configured to serve the static files from the `public` directory (where the React build files are copied).
- Adjust any other paths and configurations according to your project structure.
