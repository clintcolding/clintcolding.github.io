# Build Jeykll site
FROM ubuntu:latest as builder
LABEL maintainer="Clint Colding <clintcolding@gmail.com>"
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install ruby-full build-essential zlib1g-dev
RUN gem install jekyll bundler
RUN chown -R jekyll /app
RUN bundle install
RUN bundle exec jekyll build

# Copy source files to nginx container
FROM nginx
COPY --from=builder /app/_site/ /usr/share/nginx/html
EXPOSE 80
