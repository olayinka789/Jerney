# -----Base image for building the application-----
FROM node:20-alpine AS build

WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm ci && npm cache clean --force

COPY . .
RUN npm run build

# -----Base image for running the application-----
FROM nginx:1.29.7-alpine-slim AS production

# Remove default nginx configuration and static files
RUN rm -rf /etc/nginx/conf.d/default.conf /usr/share/nginx/html/*

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built application from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Set ownership and permissions for nginx as it runs as a non-root user
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]