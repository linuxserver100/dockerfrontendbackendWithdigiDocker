#frontend build docker file
FROM node:10-alpine

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3001

# done by sandy not pre writtenCMD ["node", "server.js"]


#backend docker buil dockerfile
FROM node:14-alpine

WORKDIR /app

# add '/app/node_modules/.bin' to $PATH
ENV PATH /app/node_modules/.bin:$PATH
# install application dependencies
COPY package*.json ./
RUN npm install
# RUN npm install react-scripts -g

# copy app files
COPY . .
# Copy built frontend files to backend
COPY --from=frontend-build /usr/src/app/build ./public

EXPOSE 3000
CMD ["npm", "start"]


