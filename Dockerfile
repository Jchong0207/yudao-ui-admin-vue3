# Use official Node.js image as a build stage
FROM node:18 AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the app files
COPY . .

# Build the Vue app
RUN npm run build

# Use a lightweight web server to serve the built Vue app
FROM nginx:latest

# Install nano in the Nginx container
RUN apt update && apt install -y certbot nano && rm -rf /var/lib/apt/lists/*

# Copy the built files from the builder stage
COPY --from=builder /app/dist-prod /usr/share/nginx/html

# Expose port 8080 (default Nginx port)
EXPOSE 8085

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
