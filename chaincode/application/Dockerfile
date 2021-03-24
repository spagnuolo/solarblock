# Pull Docker-Image of lates nodejs 14.
FROM node:14

# Create app directory.
WORKDIR /usr/src/app

# Install app dependencies.
COPY package*.json ./
RUN npm install

# Add app files.
COPY . .

# Mapped by the docker daemon.
EXPOSE 8000

# Command to start the server.
CMD [ "node", "server.js" ]
