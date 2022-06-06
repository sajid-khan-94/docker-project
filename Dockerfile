FROM centos:latest
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
ADD https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/e/epel-release-8-15.el8.noarch.rpm .
RUN rpm -ivh epel-release-8-15.el8.noarch.rpm
RUN yum install java -y
RUN mkdir /opt/tomcat
WORKDIR /opt/tomcat
ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.62/bin/apache-tomcat-9.0.62.tar.gz .
RUN tar -xvzf apache-tomcat-9.0.62.tar.gz
RUN mv apache-tomcat-9.0.62/* /opt/tomcat/
#COPY ./*.war /opt/tomcat/webapps/
EXPOSE 8080
ADD https://www.free-css.com/assets/files/free-css-templates/download/page279/jack-and-rose.zip .
RUN yum install unzip -y
RUN unzip jack-and-rose.zip
RUN mv free-wedding-website-template/ weeding
RUN mv weeding /opt/tomcat/webapps/
RUN rm -rf weeding
CMD ["/opt/tomcat/bin/catalina.sh","run"]
