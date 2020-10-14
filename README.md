# OQS Software stack for client

This is a Quantum Safe Crypto (QSC)-enabled demonstration packaging for Client

## Motivation

In order to demonstrate the utility of QSC algorithms the [Open Quantum Safe (OQS) project](https://openquantumsafe.org) provides a collection of all QSC algoritms that are part of the [NIST competition](https://csrc.nist.gov/Projects/Post-Quantum-Cryptography) within the [liboqs](https://github.com/open-quantum-safe/liboqs) library. At application level, integrations of [OpenSSL](https://github.com/open-quantum-safe/openssl) and [curl](https://github.com/curl/curl) exist to document how well QSC algorithms fit into the existing open source security application landscape.

### Components

The build script compiles following QSC-enabled components (all installed in `$HOME/opt/oqssa`):

- liboqs: All NIST-round 2 competition algorithms
- openssl: QSC-enabled OpenSSL library and utility applications
- curl: Patched curl v7.69.1

## How to build and install OQSSA
Note: Compiling and installing OQSSA requires following packages installed on the system. Please make sure these prerequites are already installed: 

* Debian (Ubuntu) dependencies: `libtool automake autoconf cmake(3.5 and above) make openssl libssl-dev build-essential git wget golang patch perl diffutils`.

```sh
echo "Starting prerequisites verification"
CMAKE_VER_REQUIRED="3.*"
packages="libtool automake autoconf cmake make openssl libssl-dev git wget build-essential golang patch perl diffutils"
for REQUIRED_PKG in $packages
do
  PKG_STATUS=$(dpkg-query -W --showformat='${Version},${Status}\n' $REQUIRED_PKG|grep "install ok installed")
  if [ "" = "$PKG_STATUS" ]
  then
      echo "$REQUIRED_PKG is NOT installed"
      #sudo apt-get -y install $REQUIRED_PKG
  else
      PKG_VER=$(echo $PKG_STATUS| cut -d',' -f 1)
      if [ "cmake" == $REQUIRED_PKG ]  && ! [[ $PKG_VER =~ $CMAKE_VER_REQUIRED ]]
      then
        echo "$REQUIRED_PKG Version is: $PKG_VER. OQSSA requires cmake 3.5 and above."
      fi
  fi
done
echo "Prerequisites verification completed"
```

* RHEL (Centos/Fedora) dependencies: `libtool automake autoconf cmake(3.5 and above) make openssl ncurses-devel gcc-c++ glibc-locale-source glibc-langpack-en openssl-devel git wget golang patch perl diffutils 'Development Tools'`

```sh
echo "Starting prerequisites verification"
CMAKE_VER_REQUIRED="3.*"
packages="git libtool automake autoconf cmake make openssl  ncurses-devel gcc-c++ openssl-devel wget glibc-locale-source glibc-langpack-en sudo golang patch perl diffutils"
for REQUIRED_PKG in $packages
do
  PKG_STATUS=$(rpm -q --qf '%{VERSION},%{INSTALLTIME}\n' $REQUIRED_PKG)
  if [[ "$PKG_STATUS" == *"not installed"* ]];
  then
    echo "$REQUIRED_PKG is NOT installed"
    #sudo yum -y install $REQUIRED_PKG
  else
      PKG_VER=$(echo $PKG_STATUS| cut -d',' -f 1)
      if [ "cmake" == $REQUIRED_PKG ]  && ! [[ $PKG_VER =~ $CMAKE_VER_REQUIRED ]]
      then
        echo "$REQUIRED_PKG Version is: $PKG_VER. OQSSA requires cmake 3.5 and above."
      fi
  fi
done
PKG_STATUS=$(yum grouplist Dev* |grep "Development Tools")
if [ "" = "$PKG_STATUS" ]
then
  echo "Developement Tools is NOT installed"
fi
echo "Prerequisites verification completed"
```

Once prerequiste packages are installed and verified, download scrit and run it:

```sh
cd $HOME
git clone git@github.com:IBM/oqssa.git
cd oqssa
bash build-oqssa.sh
```

Follow steps in [Key Protect Go SDK](https://cloud.ibm.com/docs/key-protect?topic=key-protect-quantum-safe-cryptography-tls-introduction#qsc-sdk-application-steps) to use OQSSA with IBM Key Protect Go Client.