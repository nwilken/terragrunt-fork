FROM hashicorp/terraform:light
MAINTAINER Jesse DeFer <terragrunt@dotd.com>

ENV TERRAGRUNT_VERSION=0.21.5
ENV TFLINT_VERSION=0.12.1
ENV TFSEC_VERSION=0.12.1
ENV TF_IN_AUTOMATION true

RUN apk add --no-cache --update git openssh-client curl
RUN adduser -D -u 1000 jenkins

RUN curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v$TERRAGRUNT_VERSION/terragrunt_linux_amd64 -o /bin/terragrunt && chmod +x /bin/terragrunt

# Using 386 because for some reason amd64 has issues in the container
RUN curl -sL https://github.com/wata727/tflint/releases/download/v$TFLINT_VERSION/tflint_linux_386.zip -o /tmp/tflint.zip && unzip /tmp/tflint.zip tflint -d /bin && chmod +x /bin/tflint

RUN curl -sL https://github.com/liamg/tfsec/releases/download/v$TFSEC_VERSION/tfsec-linux-amd64 -o /bin/tfsec && chmod +x /bin/tflint

RUN mkdir -p /home/jenkins/.ssh && chmod 0700 /home/jenkins/.ssh && echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> /home/jenkins/.ssh/config && chmod 0600 /home/jenkins/.ssh/config && chown -R jenkins:jenkins /home/jenkins/.ssh

COPY tflint.hcl /etc
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["terragrunt"]
