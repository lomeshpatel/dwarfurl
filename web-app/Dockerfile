ARG BUILDER_IMAGE="node:17-alpine"
ARG RUNNER_IMAGE="nginx:1.21-alpine"

# Stage 1 - Build the app
FROM ${BUILDER_IMAGE} as build

WORKDIR /app

# Set the node environment to production in order fetch proudction only dependencies
ENV NODE_ENV="production"

# Copy package.json and the lock file
COPY ./package.json ./
COPY ./package-lock.json ./

# Install all production dependencies listed in package.json
RUN npm install

# Copy all the source code
COPY . ./

# Build the app
RUN npm run build

# Stage 2 - Deploy the app and start the web server
FROM ${RUNNER_IMAGE}

#Copy built static files
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]