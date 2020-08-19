# OQS Software stack for client

This is a Quantum Safe Crypto (QSC)-enabled demonstration packaging for Client

## Motivation

In order to demonstrate the utility of QSC algorithms the [Open Quantum Safe (OQS) project](https://openquantumsafe.org) provides a collection of all QSC algoritms that are part of the [NIST competition](https://csrc.nist.gov/Projects/Post-Quantum-Cryptography) within the [liboqs](https://github.com/open-quantum-safe/liboqs) library. At application level, integrations of [OpenSSL](https://github.com/open-quantum-safe/openssl) and [curl](https://github.com/curl/curl) exist to document how well QSC algorithms fit into the existing open source security application landscape.

### Components

The install image conatins following QSC-enabled components (all installed in `/opt/oqssa`):

- liboqs: All NIST-round 3 competition algorithms
- openssl: QSC-enabled OpenSSL 1.1.1 library and utility applications
- curl: Patched curl v7.69.1

## How to download the install image from command line directly
```
curl -u <your-github-id>:<your-personal-github-access-token> https://api.github.com/repos/IBM/oqssa/releases/latest | grep "browser_download_url" | cut -d '"' -f 4 | wget -i -
```

### Reference: [How to create your personal github access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
