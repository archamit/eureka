From ubuntu:trusty
RUN apt-get -y update
RUN apt-get -y install wget
RUN apt-get -y install libxml2-utils
ENTRYPOINT /bin/bash
ENTRYPOINT server="http://8ac2b137.ngrok.io/artifactory"
ENTRYPOINT repo="eureka"
ENTRYPOINT name="eureka"
ENTRYPOINT artifact=$name
ENTRYPOINT path=$server/$repo/$artifact
ENTRYPOINT wget "$path/maven-metadata.xml"
ENTRYPOINT let itemsCount=$(xmllint --xpath 'count(//versioning/versions/version)' maven-metadata.xml)
ENTRYPOINT #echo $itemsCount
ENTRYPOINT artifactId="$(xmllint --xpath '//artifactId' maven-metadata.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g')"
ENTRYPOINT echo $artifactId;
ENTRYPOINT lastUpdated="$(xmllint --xpath '//lastUpdated' maven-metadata.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g')"
ENTRYPOINT echo $lastUpdated;
ENTRYPOINT lastUpdatedfirst8=$(echo $lastUpdated| cut -c1-8)
ENTRYPOINT echo $lastUpdatedfirst8;
ENTRYPOINT lastsnapshotname="$(xmllint --xpath '//versioning/versions/version['$itemsCount']' maven-metadata.xml | sed '/^\/ >/d' | sed 's/<[^>]*.//g')"
ENTRYPOINT echo $lastsnapshotname;
ENTRYPOINT lastreleasenumber=$(echo $lastsnapshotname| cut -d'-' -f 1)
ENTRYPOINT echo $lastreleasenumber;
ENTRYPOINT hyphen="-"
ENTRYPOINT filename=$artifactId$hyphen$lastreleasenumber
ENTRYPOINT echo $filename
ENTRYPOINT echo $path/$lastreleasenumber/$filename.jar
ENTRYPOINT wget $path/$lastreleasenumber/$filename.jar
ENTRYPOINT rm "maven-metadata.xml"
ENTRYPOINT echo $filename
EXPOSE 1111
ENTRYPOINT ["java","-jar",$filename]

