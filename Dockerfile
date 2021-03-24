FROM openjdk:8-jre AS build-env

LABEL maintainer="Chaitanya <chaitanyayadav22@gmail.com>"

ADD https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.2.zip /apache-jmeter.zip
RUN unzip /apache-jmeter.zip -d / 

RUN curl -L -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && chmod u+x /usr/bin/jq

FROM openjdk:8-jre AS runtime-env

COPY --from=build-env /apache-jmeter-5.2 /jmeter
COPY --from=build-env /usr/bin/jq /usr/bin/jq

RUN ln -s /jmeter/bin/jmeter /usr/local/bin/jmeter

# Copy plugins folder under ext folder
COPY plugins/ /jmeter/lib/ext/

COPY postgresquery.jmx /jmeter/postgresquery.jmx

# Copy MSSQL and PostgreSQL JDBC Drivers
COPY jdbc/postgresql-42.2.19.jar /jmeter/lib/
COPY jdbc/sqljdbc4.jar /jmeter/lib/
COPY jdbc/mongo-java-driver-3.12.8.jar /jmeter/lib/
COPY jdbc/mongojdbc3.1.jar /jmeter/lib/

# Change workdir to /jmeter
WORKDIR /jmeter

#RUN jmeter -n -t ./postgresquery.jmx -l ./output.txt

#CMD [ "cat", "output.txt" ]
#CMD ["sleep" , "1000"]
