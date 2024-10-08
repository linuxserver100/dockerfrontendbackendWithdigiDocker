FROM node:14 AS frontend-build

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH
# install application dependencies
COPY package*.json ./
RUN npm install
# RUN npm install react-scripts -g

# copy app files
COPY . .
# Stage 2: Build Backend
FROM node:14 AS backend-build

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .
# Stage 3: Final image
FROM node:14

# Copy built frontend files from frontend-build stage
COPY --from=frontend-build /app/build /usr/src/app/public

WORKDIR /usr/src/app
COPY --from=backend-build /usr/src/app .

EXPOSE 3001
CMD ["npm", "start"]  # Adjust this command to start your backend
