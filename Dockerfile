FROM nginx:alpine

# Copy the application files to nginx html directory
COPY . /usr/share/nginx/html/

# Remove default nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create a script to handle PORT environment variable
RUN echo '#!/bin/sh' > /docker-entrypoint.sh && \
    echo 'PORT=${PORT:-80}' >> /docker-entrypoint.sh && \
    echo 'sed -i "s/listen 80/listen $PORT/g" /etc/nginx/conf.d/default.conf' >> /docker-entrypoint.sh && \
    echo 'nginx -g "daemon off;"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Expose the port (default 80, but can be overridden)
EXPOSE ${PORT:-80}

# Use custom entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]