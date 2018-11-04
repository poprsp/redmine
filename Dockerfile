# Use the official Ruby-alpine image.  According to the Redmine docs[1],
# the latest stable version of Redmine (the 3.4.x branch) support Ruby <=2.4
#
# https://www.redmine.org/projects/redmine/wiki/redmineinstall
FROM ruby:2.4-alpine

# Some Redmine dependencies (nokogiri, RMagick, ...) builds native
# extensions, which require a C compiler.
RUN apk add --update build-base

# The RMagick gem requires imagemagick.
RUN apk add --update imagemagick6-dev

# The PostgreSQL gem needs the header files and library for postgres
RUN apk add --update postgresql-dev

# tzdata is needed to run the server
RUN apk add --update tzdata

# Required by wait-for-it.sh
RUN apk add --update bash

# Destination directory for Redmine
ENV REDMINE_DST /redmine
RUN mkdir -p $REDMINE_DST
WORKDIR $REDMINE_DST

# Cache gems
COPY Gemfile Gemfile

# Setup Redmine
COPY . .
RUN bundle install
