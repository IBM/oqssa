# OQS Software stack for client

This is a Quantum Safe Crypto (QSC)-enabled demonstration packaging for Client

## Motivation

In order to demonstrate the utility of QSC algorithms the [Open Quantum Safe (OQS) project](https://openquantumsafe.org) provides a collection of all QSC algoritms that are part of the [NIST competition](https://csrc.nist.gov/Projects/Post-Quantum-Cryptography) within the [liboqs](https://github.com/open-quantum-safe/liboqs) library. At application level, integrations of [OpenSSL](https://github.com/open-quantum-safe/openssl) and [curl](https://github.com/curl/curl) exist to document how well QSC algorithms fit into the existing open source security application landscape.

### Components

The build script compiles following QSC-enabled components (all installed in `$HOME/opt/oqssa`):

- liboqs: All NIST-round 2 competition algorithms
- openssl: QSC-enabled OpenSSL 1.1.1g library and utility applications
- curl: Patched curl v7.69.1

## How to build and install QSSA
Note: Compiling and installing OQSSA requires following packages installed on the system. Please make sure these prerequites are already installed: 

* Debian (Ubuntu) dependencies: `libtool automake autoconf cmake(3.5 and above) make openssl libssl-dev build-essential git wget golang patch perl diffutils`

```sh
packages="libtool automake autoconf cmake make openssl libssl-dev git wget build-essential golang patch perl diffutils"
for REQUIRED_PKG in $packages;
do
  PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
  #echo Checking for $REQUIRED_PKG: $PKG_OK
  if [ "" = "$PKG_OK" ];
  then
    echo "No $REQUIRED_PKG. Installing $REQUIRED_PKG."
    sudo apt-get -y install $REQUIRED_PKG
    exit_on_error $?
  fi
done
```

* RHEL (Centos/Fedora) dependencies: `libtool automake autoconf cmake(3.5 and above) make openssl ncurses-devel gcc-c++ glibc-locale-source glibc-langpack-enopenssl-devel git wget golang patch perl diffutils`

```sh
packages="git libtool automake autoconf cmake make openssl  ncurses-devel gcc-c++ openssl-devel wget glibc-locale-source glibc-langpack-en sudo golang patch perl diffutils"
for REQUIRED_PKG in $packages;
do
  PKG_NOT_FOUND=$(rpm -q $REQUIRED_PKG)
  #echo Checking for $REQUIRED_PKG: $PKG_NOT_FOUND
  if [[ "$PKG_NOT_FOUND" == *"not installed"* ]];
  then
    echo "No $REQUIRED_PKG. Installing $REQUIRED_PKG."
    sudo yum -y install $REQUIRED_PKG
    exit_on_error $?
  fi
done
```

Once prerequiste packages are installed and verified, download scrit and run it:

```sh
cd $HOME
git clone git@github.com:IBM/oqssa.git
cd oqssa
bash build-oqssa.sh
```
