FROM ruby:3.1.3

RUN apt-get update && \
  apt-get install -y software-properties-common build-essential && \
  mkdir -p /opt/apps/tree

COPY . /opt/apps/tree
WORKDIR /opt/apps/tree

RUN gem install bundler && bundle install --jobs 8 && \
  rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/* && \
  echo 'gem: --no-document' > /root/.gemrc



EXPOSE 3000 80

CMD ["./script/init_local"]
