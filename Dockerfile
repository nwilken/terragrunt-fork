FROM hashicorp/terraform:light
MAINTAINER Jesse DeFer <terragrunt@dotd.com>

ENV TERRAGRUNT_VERSION=0.13.23
ENV TERRAGRUNT_TFPATH=/bin/terraform

RUN curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v$TERRAGRUNT_VERSION/terragrunt_linux_amd64 -o /bin/terragrunt && chmod +x /bin/terragrunt

RUN apk add --update git openssh-client
RUN adduser -D -u 1000 jenkins

RUN mkdir -p /home/jenkins/.ssh && chmod 0700 /home/jenkins/.ssh && echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/jenkins/.ssh/config && chmod 0600 /home/jenkins/.ssh/config && chown -R jenkins:jenkins /home/jenkins/.ssh

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["terragrunt"]
