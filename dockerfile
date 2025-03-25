# Use Tomcat base image with JDK8
FROM tomcat:8.5.72-jdk8-openjdk-buster

# Set environment variables for Maven
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_VERSION 3.8.4
ENV PATH $MAVEN_HOME/bin:$PATH

# Install Maven
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar -xzf - -C /usr/share && \
    mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven && \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory for the app
WORKDIR /app

# Copy Maven project files and source code into the container
COPY ./pom.xml ./pom.xml
COPY ./src ./src

# Run Maven to build the application (mvn package)
RUN mvn package

# Copy the WAR file to Tomcat's webapps directory
RUN cp /app/target/addressbook.war /usr/local/tomcat/webapps

# Expose port 8080 for Tomcat
EXPOSE 8080

# Start Tomcat server when the container starts
CMD ["catalina.sh", "run"]
 
