FROM centos:latest
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
ADD https://download-ib01.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/e/epel-release-8-15.el8.noarch.rpm .
RUN rpm -ivh epel-release-8-15.el8.noarch.rpm 
RUN yum install java -y
RUN mkdir /opt/tomcat
WORKDIR /opt/tomcat
ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.64/bin/apache-tomcat-9.0.64.tar.gz .
RUN tar -xvzf apache-tomcat-9.0.64.tar.gz
RUN mv apache-tomcat-9.0.64/* /opt/tomcat/
#COPY ./*.war /opt/tomcat/webapps/
RUN sed -i 's/8080/8088/g' /opt/tomcat/conf/server.xml
EXPOSE 8088
RUN echo '<tomcat-users xmlns="http://tomcat.apache.org/xml"' > /opt/tomcat/conf/tomcat-users.xml
RUN echo '              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '              version="1.0">' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<role rolename="manager-gui"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<role rolename="manager-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<role rolename="manager-jmx"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<role rolename="manager-status"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<user username="deployer" password="deployer" roles="manager-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<user username="tomcat" password="s3cret" roles="manager-gui"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '</tomcat-users>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' | tee  /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml >/dev/null
RUN echo '<Context antiResourceLocking="false" privileged="true" >' | tee -a /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml >/dev/null
RUN echo '  <CookieProcessor className="org.apache.tomcat.util.http.Rfc6265CookieProcessor"' | tee -a /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml >/dev/null
RUN echo '				   sameSiteCookies="strict" />' | tee -a /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml >/dev/null
RUN echo '	<!--			   ' | tee -a /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml >/dev/null
RUN echo '    <Valve className="org.apache.catalina.valves.RemoteAddrValve"' | tee -a /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml >/dev/null
RUN echo '		 allow="\127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1" />' | tee -a /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml >/dev/null
RUN echo '  -->' | tee -a /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml >/dev/null
RUN echo '  <Manager sessionAttributeValueClassNameFilter="java\.lang\.(?:Boolean|Integer|Long|Number|String)|org\.apache\.catalina\.filters\.CsrfPreventionFilter\$LruCache(?:\$1)?|java\.util\.(?:Linked)?HashMap"/>' | tee -a /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml >/dev/null
RUN echo '</Context>' | tee -a /opt/tomcat/webapps/host-manager/META-INF/context.xml /opt/tomcat/webapps/manager/META-INF/context.xml >/dev/null
ADD https://www.free-css.com/assets/files/free-css-templates/download/page279/jack-and-rose.zip .
RUN yum install unzip -y
RUN unzip jack-and-rose.zip
RUN mv free-wedding-website-template/ /opt/tomcat/webapps/wedd
RUN rm -rf free-wedding-website-template
CMD ["/opt/tomcat/bin/catalina.sh","run"]
