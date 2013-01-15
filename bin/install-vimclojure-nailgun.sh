set -e

#hg clone https://bitbucket.org/kotarak/vimclojure
wget http://kotka.de/projects/vimclojure/vimclojure-nailgun-client-2.3.6.zip
unzip vimclojure-nailgun-client-2.3.6.zip
cd client
make
mv ng ~/.bin

wget http://clojars.org/repo/vimclojure/server/2.3.6/server-2.3.6.jar ~/bin/server-2.3.6.jar

