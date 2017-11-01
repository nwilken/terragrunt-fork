FROM hashicorp/terraform:light
MAINTAINER Jesse DeFer <terragrunt@dotd.com>

ENV TERRAGRUNT_VERSION=0.13.15
ENV TERRAGRUNT_TFPATH=/bin/terraform

RUN curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v$TERRAGRUNT_VERSION/terragrunt_linux_amd64 -o /bin/terragrunt && chmod +x /bin/terragrunt

RUN apk add --update git openssh-client
RUN adduser -D -u 1000 jenkins

ENTRYPOINT ["/bin/terragrunt"]
