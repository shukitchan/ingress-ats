FROM centos:7

RUN yum -y update; \
    # Compilers
    yum -y install ccache make pkgconfig bison flex gcc-c++ clang \
    # Autoconf
    autoconf automake libtool \
    # Various other tools
    git rpm-build distcc-server file wget openssl hwloc; \
    # Devel packages that ATS needs
    yum -y install openssl-devel expat-devel pcre-devel libcap-devel hwloc-devel libunwind-devel \
    xz-devel libcurl-devel ncurses-devel jemalloc-devel GeoIP-devel luajit-devel brotli-devel \
    ImageMagick-devel ImageMagick-c++-devel hiredis-devel \
    perl-ExtUtils-MakeMaker perl-Digest-SHA perl-URI tcl-devel json-c-devel;\
    # This is for autest stuff
    yum -y install python3 httpd-tools procps-ng nmap-ncat pipenv \
    python3-virtualenv python3-gunicorn python3-requests python3-httpbin

RUN  if [ ! -z "$(grep -i centos /etc/redhat-release)" ]; then \
    yum -y install centos-release-scl; \
    yum -y install devtoolset-7 devtoolset-7-libasan-devel; \
    fi 

RUN curl -L https://www-us.apache.org/dist/trafficserver/trafficserver-7.1.6.tar.bz2 | bzip2 -dc | tar xf - \
    && cd trafficserver-7.1.6/ \
    && autoreconf -if \
    && ./configure --enable-debug=yes --enable-experimental-plugins=yes \
    && make \
    && make install 

RUN wget https://github.com/torchbox/k8s-ts-ingress/archive/v1.0.0-alpha10-dev4.tar.gz \
    && tar zxvf v1.0.0-alpha10-dev4.tar.gz \
    && cd k8s-ts-ingress-1.0.0-alpha10-dev4/ \
    && autoreconf -if \
    && ./configure --with-tsxs=/usr/local/bin/tsxs --with-build-id=unknown \
    && make \
    && cp kubernetes.so /usr/local/libexec/trafficserver/

COPY ["./plugin.config", "/usr/local/etc/trafficserver/plugin.config"]
COPY ["./records.config", "/usr/local/etc/trafficserver/records.config"]
COPY ["./logging.config", "/usr/local/etc/trafficserver/logging.config"]
COPY ["./entry.sh", "/usr/local/bin/entry.sh"]

ENTRYPOINT ["/usr/local/bin/entry.sh"]

