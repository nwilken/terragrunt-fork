FROM hashicorp/terraform:light
MAINTAINER Jesse DeFer <terragrunt@dotd.com>

ENV TERRAGRUNT_VERSION=0.18.6
ENV TERRAGRUNT_TFPATH=/bin/terraform

ENV SCENERY_VERSION=0.1.5

RUN apk add --no-cache --update git openssh-client ruby ruby-json jq
RUN apk add --no-cache ruby-dev make gcc musl-dev curl
RUN adduser -D -u 1000 jenkins

RUN curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v$TERRAGRUNT_VERSION/terragrunt_linux_amd64 -o /bin/terragrunt && chmod +x /bin/terragrunt

RUN curl -sL https://github.com/dmlittle/scenery/releases/download/v$SCENERY_VERSION/scenery-v$SCENERY_VERSION-linux-amd64 -o /bin/scenery && chmod +x /bin/scenery

RUN mkdir -p /home/jenkins/.ssh && chmod 0700 /home/jenkins/.ssh && echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/jenkins/.ssh/config && chmod 0600 /home/jenkins/.ssh/config && chown -R jenkins:jenkins /home/jenkins/.ssh && gem install --no-document --no-ri terraform_landscape

RUN apk del ruby-dev make gcc musl-dev curl

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["terragrunt"]
