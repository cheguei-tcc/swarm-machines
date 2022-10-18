FROM nginx

# copy the config files
RUN rm -rf /etc/nginx/nginx.conf

COPY policy.html /usr/share/nginx/html/index.html
COPY nginx.conf /etc/nginx/