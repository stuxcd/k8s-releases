FROM jenkins

ENV S3_ENDPOINT ''
ENV AWS_ACCESS_KEY_ID ''
ENV AWS_SECRET_ACCESS_KEY ''

RUN /usr/local/bin/install-plugins.sh ldap workflow-job workflow-aggregator pipeline credentials-binding git configuration-as-code kubernetes kubernetes-credentials-provider

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.4 get-pip.py
RUN pip3 install pip3 install awscli --user

RUN aws --version
