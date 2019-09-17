# Build Jeykll site
FROM alpine as builder
LABEL maintainer="Clint Colding <clintcolding@gmail.com>"
WORKDIR /app
COPY . .
RUN chown -R jekyll /app
RUN apk add --update ruby \
    && apk add --virtual build-dependencies build-base ruby-dev libffi-dev \
    && gem install bundler --no-ri --no-rdoc \
    && bundle install --without development test \
    && gem cleanup \
    && apk del build-dependencies
RUN bundle exec jekyll build

# Copy source files to nginx container
FROM nginx
COPY --from=builder /app/_site/ /usr/share/nginx/html
EXPOSE 80