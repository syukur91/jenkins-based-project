FROM ubuntu:16.04
MAINTAINER Syukur Achmad

#install package ansible
RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && apt-get -y --no-install-recommends install software-properties-common language-pack-en-base
RUN add-apt-repository ppa:deadsnakes
RUN add-apt-repository ppa:ansible/ansible
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y autoremove
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install wget git curl rsync python-pip python-software-properties libfontconfig1
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install ansible

#copy key
COPY certs/id_rsa /root/.ssh/id_rsa
COPY certs/id_rsa.pub /root/.ssh/id_rsa.pub
COPY inventory /etc/ansible/hosts

#java openjdk11
RUN add-apt-repository ppa:openjdk-r/ppa && apt-get update && apt install -y openjdk-11-jdk
RUN echo "JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/" >> /etc/environment

RUN echo -e "StrictHostKeyChecking no\nUserKnownHostsFile=/dev/null" >> /root/.ssh/config
COPY certs/config /root/.ssh/
RUN chmod 700 /root/.ssh/*

#install python3.6
RUN apt-get -y install python3.6 python3.6-dev python3.6-venv
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.6 get-pip.py
RUN echo -e "alias python='/usr/bin/python3.6'" >> /root/.bashrc
RUN echo -e "alias pip='/usr/bin/pip3.6'" >> /root/.bashrc
RUN python3.6 -m pip install --upgrade pip
RUN python3.6 -m pip install boto3 pypdf nose
RUN python3.6 -m pip install django==1.11.1 django-silk==1.0.0 pillow==4.1.1 coverage==4.4.1 elasticsearch==5.3.0 pyyaml==3.12 djangorestframework==3.6.2 djangorestframework-jwt==1.10.0 djangorestframework-camel-case==0.2.0 django-rest-swagger==2.1.2 ipython Flask==0.12.2 pytz>=2017.2 requests>=2.18.1 Flask-SQLAlchemy>=2.2 alembic>=0.9.3 psycopg2>=2.7.2 flask-marshmallow>=0.8.0 marshmallow-sqlalchemy>=0.13.1 marshmallow-enum>=1.2 pyjwt>=1.5.2 factory-boy>=2.8.1 mock>=2.0.00 humanize==0.5.1 python3-memcached==1.51 django-filter==1.0.4 Unidecode==0.4.21 sorl-thumbnail==12.3 social-auth-app-django==1.2.0

#install php7.1
RUN LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php
RUN rm -rf etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list
RUN apt-get update
RUN apt-get -y install php7.1-curl php7.1-xml php7.1-zip php7.1-gd php7.1-common php7.1-cli php7.1-mysql php7.1-mbstring

#install nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get -y install nodejs

#install imagemagick & ghostscript
RUN \
  apt-get update && \
  apt-get -y install \
   ghostscript \
   imagemagick \
   groff \
   p7zip-full

#install go 1.11
RUN wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz
RUN tar -xvf go1.11.linux-amd64.tar.gz && mv go /usr/local && rm -rf go1.11.linux-amd64.tar.gz

#setup go environment
RUN export GOROOT=/usr/local/go
RUN export GOPATH=/home/ubuntu
RUN export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

#Install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install -y docker-ce

#Install aws-cli
RUN apt-get install -y awscli

#Install kubectl
RUN curl -L https://storage.googleapis.com/kubernetes-release/release/v1.9.0/bin/linux/amd64/kubectl -o /usr/bin/kubectl
RUN chmod +x /usr/bin/kubectl

#Install php composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer

#clear all cache
RUN apt-get clean