FROM ruby:2.7.7-alpine3.16 AS builder

# nokogiri, json
RUN apk --no-cache add make libxml2 libxslt-dev g++

# Application dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# The final image: we start clean
FROM ruby:2.7.7-alpine3.16

# We copy over the entire gems directory for our builder image, containing the already built artifact
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

COPY tracks.rb ./

ENTRYPOINT ["ruby", "tracks.rb"]
