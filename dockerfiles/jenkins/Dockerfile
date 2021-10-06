FROM jenkins/jenkins:latest

ENV S3_ENDPOINT ''
ENV AWS_ACCESS_KEY_ID ''
ENV AWS_SECRET_ACCESS_KEY ''

USER root
RUN /usr/local/bin/install-plugins.sh ldap \
    workflow-job \
    workflow-aggregator \
    credentials-binding \
    git \
    configuration-as-code \
    kubernetes \
    kubernetes-credentials-provider \
    role-strategy \
    generic-webhook-trigger

USER jenkins
