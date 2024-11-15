# Use a Debian-based Node.js image with version v22.1.0
FROM node:22.1.0-slim

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

RUN npm run build

# Run chmod to a file
RUN chmod +x seed-data/init-mongo.sh

# Expose the application port
EXPOSE 8000

# Start the Node.js server
CMD ["npm", "start"]
