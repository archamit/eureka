From ubuntu:trusty
RUN apt-get -y update
RUN apt-get -y install wget
RUN apt-get -y install libxml2-utils
RUN server="http://897e3efb.ngrok.io/artifactory"
RUN repo="eureka"
RUN name="eureka"
RUN artifact=$name
RUN path=$server/$repo/$artifact
RUN mvnMetadata=$(curl -s "$path/maven-metadata.xml")
RUN tomcatpath=/usr/local/apache-tomcat-8.5.9/webapps/
RUN wget "$path/maven-metadata.xml"
RUN let itemsCount=$(xmllint --xpath 'count(//versioning/versions/version)' maven-metadata.xml)
RUN #echo $itemsCount
RUN artifactId="$(xmllint --xpath '//artifactId' maven-metadata.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g')"
RUN echo $artifactId;
RUN lastUpdated="$(xmllint --xpath '//lastUpdated' maven-metadata.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g')"
RUN echo $lastUpdated;
RUN lastUpdatedfirst8=$(echo $lastUpdated| cut -c1-8)
RUN echo $lastUpdatedfirst8;
RUN lastsnapshotname="$(xmllint --xpath '//versioning/versions/version['$itemsCount']' maven-metadata.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g')"
RUN echo $lastsnapshotname;
RUN lastreleasenumber=$(echo $lastsnapshotname| cut -d'-' -f 1)
RUN echo $lastreleasenumber;
RUN hyphen="-"
RUN filename=$artifactId$hyphen$lastreleasenumber
RUN echo $filename
RUN echo $path/$lastreleasenumber/$filename.jar
RUN wget $path/$lastreleasenumber/$filename.jar
RUN rm "maven-metadata.xml"

EXPOSE 1111
ENTRYPOINT ["java","-jar",$filename]

