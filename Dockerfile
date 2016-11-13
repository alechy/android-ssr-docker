FROM ubuntu
MAINTAINER alechy
RUN apt-get update -y 
RUN apt-get dist-upgrade -y
RUN apt-get install git golang openjdk-8-jdk -y
RUN apt-get install openssh-server -y
RUN mkdir /var/run/sshd
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-get update
RUN apt-get install sbt
RUN cd /opt && git clone https://git.oschina.net/alechy/net.alechy.ml.ssr
RUN export GOROOT_BOOTSTRAP=/usr/lib/go-1.6
RUN cd /opt/net.alechy.ml.ssr && git submodule update --init
RUN sbt native-build clean android:package-release
ENTRYPOINT /usr/sbin/sshd -D

