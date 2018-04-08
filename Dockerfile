From ubuntu:trusty
RUN apt-get -y update
RUN apt-get -y install wget
RUN apt-get -y install libxml2-utils
server="http://897e3efb.ngrok.io/artifactory"
repo="eureka"
name="eureka"
artifact=$name
path=$server/$repo/$artifact
mvnMetadata=$(curl -s "$path/maven-metadata.xml")
tomcatpath=/usr/local/apache-tomcat-8.5.9/webapps/
wget "$path/maven-metadata.xml"
let itemsCount=$(xmllint --xpath 'count(//versioning/versions/version)' maven-metadata.xml)
#echo $itemsCount
artifactId="$(xmllint --xpath '//artifactId' maven-metadata.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g')"
echo $artifactId;
lastUpdated="$(xmllint --xpath '//lastUpdated' maven-metadata.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g')"
echo $lastUpdated;
lastUpdatedfirst8=$(echo $lastUpdated| cut -c1-8)
echo $lastUpdatedfirst8;
lastsnapshotname="$(xmllint --xpath '//versioning/versions/version['$itemsCount']' maven-metadata.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g')"
echo $lastsnapshotname;
lastreleasenumber=$(echo $lastsnapshotname| cut -d'-' -f 1)
echo $lastreleasenumber;
hyphen="-"
filename=$artifactId$hyphen$lastreleasenumber
echo $filename
echo $path/$lastreleasenumber/$filename.jar
wget $path/$lastreleasenumber/$filename.jar
rm "maven-metadata.xml"

EXPOSE 1111
ENTRYPOINT ["java","-jar",$filename]

