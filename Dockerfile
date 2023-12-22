FROM nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY website/nginx.conf /etc/nginx/conf.d/default.conf
COPY website/content /var/www/html