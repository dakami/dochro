FROM hurricane/dockergui:x11rdp
# set variables
# User/Group Id gui app will be executed as default are 99 and 100
ENV USER_ID=99 GROUP_ID=100 APP_NAME="DoChro" WIDTH=1420 HEIGHT=840 TERM=xterm DEBIAN_FRONTEND=noninteractive HOME=nobody  PATH="/nobody/depot_tools:${PATH}" NINJA_BUILD="" XDG_RUNTIME_DIR="/tmp"

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# start files and config etc....
RUN \
cd /etc/my_init.d; \
bash ./00_config.sh && \
bash ./01_user_config.sh && \
bash ./02_app_config.sh && \
rm /etc/my_init.d/* && \
echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted multiverse' > /etc/apt/sources.list && \
echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted multiverse' >> /etc/apt/sources.list && \
echo 'deb-src http://archive.ubuntu.com/ubuntu trusty main universe restricted multiverse' >> /etc/apt/sources.list && \
echo 'deb-src http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted multiverse' >> /etc/apt/sources.list && \
echo debconf shared/accepted-oracle-license-v1-1 select true | \
  sudo debconf-set-selections; sleep 1; \
 echo debconf shared/accepted-oracle-license-v1-1 seen true | \
  sudo debconf-set-selections; \ 
#add-apt-repository ppa:webupd8team/java && \
apt-get -y update && \
apt-get -y install build-essential make g++ git python bash \
icewm rxvt \
gdb lldb-3.8 \
wget curl \
libexpat1-dev build-essential g++ make flex bison \
git \
python-xdg xvfb parallel; \
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections;   \
 
wget http://cdn.azul.com/zulu/bin/zulu8.17.0.3-jdk8.0.102-linux_amd64.deb && \
dpkg -i zulu8.17.0.3-jdk8.0.102-linux_amd64.deb && \

pwd
# Add local files
USER nobody
RUN \
cd /nobody; \
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git && \
mkdir /nobody/chromium; \
cd /nobody/chromium; \
fetch --no-history chromium 
USER root
RUN \
cd /nobody/chromium/src/; \
pwd; \
ls; \
echo y | ./build/install-build-deps.sh 
ADD src/ /nobody/src
RUN \
chown -R nobody /nobody/src; \
chmod -R 0777 /nobody/src; \
mv /nobody/src/startapp.sh /; \

pwd
USER nobody
RUN \
cd /nobody; \
git clone git://github.com/budhash/install-eclipse && \
./install-eclipse/install-eclipse -o -p "http://download.eclipse.org/releases/neon,org.eclipse.cdt.feature.group" eclipse; 
RUN \
mv /nobody/src/* /nobody && \
cd /nobody/chromium/src; \
mkdir -p out/Debug && \
cp /nobody/args.gn out/Debug && \
gn gen --ide=eclipse -C out/Debug ; \

cp /nobody/project /nobody/chromium/src/.project && \
cp /nobody/cproject /nobody/chromium/src/.cproject && \
cp -r /nobody/settings /nobody/chromium/src/.settings;
RUN \
sed -i 's/gdb_index = false/gdb_index = true/' /nobody/chromium/src/build/config/compiler/BUILD.gn; \
cd /nobody/chromium/src/out/Debug/; \
ninja -v; 
RUN \
cd / && \
echo "-startup plugins/org.eclipse.equinox.launcher_1.3.201.v20161025-1711.jar --launcher.library plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.1.401.v20161122-1740 -showsplash org.eclipse.platform --launcher.defaultAction openFile --launcher.appendVmargs -vmargs -Dosgi.requiredJavaVersion=1.8 -XX:+UseG1GC -XX:+UseStringDeduplication -DXms48000m -DXmx48000m" | tr " " "\n" > /nobody/eclipse/eclipse.ini; \
cp /nobody/eclipse/eclipse.ini /nobody; \
cat /nobody/eclipse/eclipse.ini && \
/nobody/fix_eclipse.sh && \
cat /nobody/eclipse/eclipse.ini && \
cd /nobody && \
xvfb-run -a /nobody/eclipse/eclipse -nosplash -consoleLog -data /nobody/workspace -application org.eclipse.cdt.managedbuilder.core.headlessbuild -import /nobody/chromium/src -build src; \
ls;
RUN \
cd /nobody; \
tar xf gdb*xz && \
rm gdb*.tar.xz && \
cd gdb-7.12; \
./configure --prefix=/usr && make
USER root
RUN \
cd /nobody/gdb-7.12; \
make install
ADD /workspace2 /nobody/workspace2
USER nobody
RUN \
cd /nobody/workspace2/workspace; \
tar czvf - . | tar xzvf - -C /nobody/workspace/
USER root
