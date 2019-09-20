FROM nginx
LABEL maintainer="Clint Colding <clintcolding@gmail.com>"
COPY ./_site/ /usr/share/nginx/html
EXPOSE 80