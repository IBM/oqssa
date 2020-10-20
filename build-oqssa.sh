#!/bin/bash

export BUILDDIR=$HOME
export INSTALLDIR=$BUILDDIR/opt/oqssa

cleanup() {
  echo "Cleaning up"
  rm -rf $BUILDDIR/liboqs
  rm -rf $BUILDDIR/curl-${CURL_VERSION}*
  rm -rf $BUILDDIR/patch-${CURL_VERSION}.*
  rm -rf $BUILDDIR/openssl
}

exit_on_error() {
    exit_code=$1
    
    if [ $exit_code -ne 0 ]; then
        >&2 echo "command failed with exit code ${exit_code}."
        cleanup
        exit $exit_code
    fi
}

echo "Setting installation dir: $BUILDDIR/opt/oqssa"

echo "Downloading liboqs and open-quantum-safe openssl"
# Download liboqs and oqs/openssl
cd $BUILDDIR
git clone --quiet --single-branch --branch master https://github.com/open-quantum-safe/liboqs 
git clone --quiet --single-branch --branch OQS-OpenSSL_1_1_1-stable https://github.com/open-quantum-safe/openssl 
exit_on_error $? 

echo "Build liboqs"
# Compile liboqs
cd $BUILDDIR/liboqs
MYCMD=$(mkdir build && cd build && cmake ..  -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=$BUILDDIR/openssl/oqs > /dev/null && make > /dev/null && make install > /dev/null)
exit_on_error $? 

echo "Build oqs-openssl"
# Compile oqs-openssl
cd $BUILDDIR/openssl
MYCMD=$(LDFLAGS="-Wl,-rpath -Wl,$INSTALLDIR/lib" ./Configure linux-x86_64 -DOQS_DEFAULT_GROUPS=\"prime256v1:secp384r1:secp521r1:X25519:X448:kyber512:kyber768:kyber1024:p256_kyber512:p384_kyber768:p521_kyber1024\" -lm --prefix=$INSTALLDIR &>/dev/null  && make &> /dev/null && make install &> /dev/null)
exit_on_error $? 

echo "Downloading libcurl"
# Download libcurl
cd $BUILDDIR
CURL_VERSION=7.69.1
wget -q  https://curl.haxx.se/download/curl-$CURL_VERSION.tar.gz && tar -zxvf curl-$CURL_VERSION.tar.gz > /dev/null
wget -q  https://raw.githubusercontent.com/open-quantum-safe/oqs-demos/master/curl/patch-$CURL_VERSION.oqs.txt
exit_on_error $? 

cd $BUILDDIR/curl-${CURL_VERSION}
MYCMD=$(patch -p1 < ${BUILDDIR}/patch-${CURL_VERSION}.oqs.txt >/dev/null)
exit_on_error $? 

echo "Build libcurl with oqs-openssl"
# Compile libcurl
MYCMD=$(CPPFLAGS="-I$INSTALLDIR" LDFLAGS=-Wl,-R${INSTALLDIR}/lib ./configure --prefix=$INSTALLDIR --with-ssl=${INSTALLDIR} &> /dev/null && make > /dev/null && make install > /dev/null)
exit_on_error $? 

export PATH=$BUILDDIR/opt/oqssa/bin:$PATH

echo "Downloading IBM Key Protect Go Client"
cd $BUILDDIR
git clone --quiet --single-branch --branch qsc-support https://github.com/IBM/keyprotect-go-client.git 
exit_on_error $? 
#mkdir $BUILDDIR/keyprotect-go-client/examples
#cp $BUILDDIR/oqssa/main_qsc.go $BUILDDIR/keyprotect-go-client/examples/

#echo "Running IBM Key Protect Go Client quantum test"
#LD_LIBRARY_PATH=$BUILDDIR/opt/oqssa/lib PKG_CONFIG_PATH=$BUILDDIR/opt/oqssa/lib/pkgconfig go test --tags quantum
#cd $BUILDDIR

cleanup

echo "Installation Complete"
