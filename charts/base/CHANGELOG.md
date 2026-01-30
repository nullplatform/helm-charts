# Changelog


## [2.33.1](https://github.com/nullplatform/helm-charts/compare/nullplatform-base-2.33.0...nullplatform-base-2.33.1) (2026-01-28)


## [2.33.0](https://github.com/nullplatform/helm-charts/releases/tag/nullplatform-base-2.33.0) (2026-01-28)


### Features

* **helm-charts:** add new features to helm charts ([fb9af0a](https://github.com/nullplatform/helm-charts/commit/fb9af0aded702f87cb7b355aafb577b1b0d543da))
* **oci:** add support to oci ([c7e0b9f](https://github.com/nullplatform/helm-charts/commit/c7e0b9fd4e745c64e491e6cd0281249aea543d8d))
* **base:** add OCI/OKE gateway support with load balancer annotations ([b784b21](https://github.com/nullplatform/helm-charts/commit/b784b218d21b48a1cb62c3d1351d9acade6ac578))
* **base:** add custom configuration ([33cebf4](https://github.com/nullplatform/helm-charts/commit/33cebf4954de1d89c68104f70af0ed688d425c7d))
* **base:** add custom configuration ([459d7bb](https://github.com/nullplatform/helm-charts/commit/459d7bba173adce9193f71098a18e7d8f3eac352))
* **logs:** add fluent conf ([2cefe46](https://github.com/nullplatform/helm-charts/commit/2cefe465792c38deb0811d1ffcc6f08f660bbb64))
* **base:** add configmaps custom ([64b011b](https://github.com/nullplatform/helm-charts/commit/64b011b3daead45086420a48c06bb45752be05ac))
* **base:** add configmaps custom ([031ab83](https://github.com/nullplatform/helm-charts/commit/031ab8371a3244ab43c1339b4613eef67717cbe0))
* **base:** add selinux for aro ([1bc916a](https://github.com/nullplatform/helm-charts/commit/1bc916ae17100a6bae4f63527e446636acf7bf06))
* **helm-charts:** add aws cert-manager & chart-base ([bbda817](https://github.com/nullplatform/helm-charts/commit/bbda817e163588d4dda89e990ba9fbdf6a17f91b))
* **certmanager:** add private certificate ([89ee117](https://github.com/nullplatform/helm-charts/commit/89ee1172f2b13b060d6f4720d4a00bc96ac12bed))
* add support to aro ([a813bfb](https://github.com/nullplatform/helm-charts/commit/a813bfb1c5e6b7183bcbaea16bb555edb3915cb2))
* **base:** edit yaml podmonitor ([c0eb54c](https://github.com/nullplatform/helm-charts/commit/c0eb54c6557eb7a54a84eb2e537e126d79200733))
* **base:** add metadata namespace for prometheus ([ffbcee7](https://github.com/nullplatform/helm-charts/commit/ffbcee7e70856db674f4e38fe79eeef486d2ada8))
* **base:** add rbac and podmonitor for prometheus operator ([9000374](https://github.com/nullplatform/helm-charts/commit/90003742a4df3922cbbdaee59e14c4e95dad7ccc))
* **agent:** support agent by namespace ([a567739](https://github.com/nullplatform/helm-charts/commit/a567739fdad69f1e97e175ef3afdc4c04397ebaa))
* **base:** edit certifcate name for ingress controller internal ([79925be](https://github.com/nullplatform/helm-charts/commit/79925be7196fb9b783fb60a6ca4692763fd422ec))
* **aro:** disambiguate ingresses for internal/external ([0c50c5c](https://github.com/nullplatform/helm-charts/commit/0c50c5c2088d2e12ae882916cabca6eb75ac893d))
* **base:** add SecurityContextConstraints to ARO ([3a2a258](https://github.com/nullplatform/helm-charts/commit/3a2a258c60cf0c320cc057fe4d025c56e84596f7))
* edit values with ingresscontroler ([821945e](https://github.com/nullplatform/helm-charts/commit/821945edd6f9ae9873d8b58677b4de1d0c7de104))
* add private controller ([ec76c01](https://github.com/nullplatform/helm-charts/commit/ec76c0197e0e6bb43072d36c05b4b2b291054d04))
* **aro:** add logic for openshift ([cb948a2](https://github.com/nullplatform/helm-charts/commit/cb948a24601b687f8d56399dfa783185c1f73313))
* **istio-metrics:** Extract istio metrics into separate chart ([905e115](https://github.com/nullplatform/helm-charts/commit/905e1153939c47aa6e32d2b3cacd968c45676c9d))
* **base:** remove job ([faa6ee3](https://github.com/nullplatform/helm-charts/commit/faa6ee31b7d251ea4e4dd5e5c91fd00010c95dbd))
* **base:** Add Istio metrics mode as alternative to log controller ([f2ea251](https://github.com/nullplatform/helm-charts/commit/f2ea25190723d2798975661e52fe0add4d544ecb))
* **base:** make prometheus port annotation configurable ([a8ec8da](https://github.com/nullplatform/helm-charts/commit/a8ec8dad4cc83417bfe81c45cdedf779503b0638))
* **base:** add annotations for prometheus auto discovery ([be18456](https://github.com/nullplatform/helm-charts/commit/be18456429275fcf84d51da239600aac617ccb1a))
* make gateway annotations cloud-aware with loadBalancerType flag ([38d41c7](https://github.com/nullplatform/helm-charts/commit/38d41c7e3dbe45f736981e6e7ecfa9a626534a4a))
* **base:** GIT-0000 Improve service account configuration for hooks ([8f00eee](https://github.com/nullplatform/helm-charts/commit/8f00eeeefe8e90b236051e2a7b2a69e61c46e141))
* **agent:** resolve conflic ([d64fcb9](https://github.com/nullplatform/helm-charts/commit/d64fcb99f90a0bb35249323cbf454daa3f7799a9))
* **docs:** Improve docs and support install in k3s ([404d3ec](https://github.com/nullplatform/helm-charts/commit/404d3ec5956936fefa6deb92c4910123339605de))
* **agent:** [main] multiple agent installations ([11e8c62](https://github.com/nullplatform/helm-charts/commit/11e8c6249e79da5f7661f00e4170426a86842fbf))
* **base:** add cloudwatch configurations ([1300104](https://github.com/nullplatform/helm-charts/commit/13001046bf3cf49586b1a7dad840a689f649ad4f))
* **base:** BAC-1546 include resource limits to logs controller containers ([bf6a85e](https://github.com/nullplatform/helm-charts/commit/bf6a85e84d27390e4923f6e0a261015209a9c4c1))
* **base:** NULL-168 added possibility to specify IPs to gateways ([dc022b5](https://github.com/nullplatform/helm-charts/commit/dc022b5a46ae8563978279880e32b4d5fae52b09))
* **base:** NULL-147 use nullplatform apikey or provide a secret with the value inside ([30acb5c](https://github.com/nullplatform/helm-charts/commit/30acb5ce29ad03a909dd828525869a6087ae41c8))
* **base:** BAC-1276 semantic versioning enabled ([3848265](https://github.com/nullplatform/helm-charts/commit/3848265368d93299230d70682a2976d573ec9c92))


### Bug Fixes

* **helm-charts:** fix comments ([f61f8ed](https://github.com/nullplatform/helm-charts/commit/f61f8ed5e884ce8304384f78c9e79ccf7df0ccd4))
* **base:** use fully qualified image name for kubectl ([5fca77a](https://github.com/nullplatform/helm-charts/commit/5fca77a611495cb00d91cca25c5df774c03330e6))
* **base:** add security groups to gateways ([04553ed](https://github.com/nullplatform/helm-charts/commit/04553ed4a71cfeb73b382a404d6eb75a91c362fa))
* **chart-base:** add balancer name for aws ([68b36ec](https://github.com/nullplatform/helm-charts/commit/68b36ecb06b5318badcf8a2cec568efd778fe1e8))
* **base:** fix values tls name ([2331b60](https://github.com/nullplatform/helm-charts/commit/2331b603f0b6fb08a814f119b816641aa78a3997))
* **base-gateways:** add annottaion to LB use subnet private ([22cb988](https://github.com/nullplatform/helm-charts/commit/22cb9887b30356c03e6961e585ceb5f44d98889c))
* **base-gateways:** add annottaion to LB use subnet private ([ef740a2](https://github.com/nullplatform/helm-charts/commit/ef740a2b1164950280993b663f34c42580920e19))
* **chart-base:** disable http option ([0704ed9](https://github.com/nullplatform/helm-charts/commit/0704ed9e91cdb10323f03ad9a1ddecf7d982be2e))
* **chart-base:** fix annotation to aws gateways ([759c21d](https://github.com/nullplatform/helm-charts/commit/759c21d9870de0f11b3028069aa16b99edeca689))
* removed security context constraints for aro since they don't work ([ee1c033](https://github.com/nullplatform/helm-charts/commit/ee1c03350497dadecb9480bdb386e0727674dbb6))
* dnsManagementPolicy is now  Unmanaged ([5aebed0](https://github.com/nullplatform/helm-charts/commit/5aebed0a9b99d75947835981dc6591133d84f6bb))
* **base:** Honour nullplatform tools ns configuration ([a6c8740](https://github.com/nullplatform/helm-charts/commit/a6c87405500a37d17613f445157ba060b3d70eea))
* **base:** resolve installGatewayV2Crd serviceaccount timing issue ([c9d697f](https://github.com/nullplatform/helm-charts/commit/c9d697f52f766a01278d1fc9f8144d4fc3bf7a7d))
* **base:** BAC-1446 keep gateways on chart deletion and prevent creation if they are already created ([2a1e5eb](https://github.com/nullplatform/helm-charts/commit/2a1e5ebabd8bd970649120f48f4a6881c81873c9))

