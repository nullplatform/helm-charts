## [2.21.2](https://github.com/nullplatform/helm-charts/compare/2.21.1...2.21.2) (2025-11-04)


### Bug Fixes

* secretName can be configured for cert manager ([2ded9dc](https://github.com/nullplatform/helm-charts/commit/2ded9dc4877af0934e80135252712f2eb277e2cb))

## [2.21.1](https://github.com/nullplatform/helm-charts/compare/2.21.0...2.21.1) (2025-11-04)


### Bug Fixes

* dnsManagementPolicy is now  Unmanaged ([5aebed0](https://github.com/nullplatform/helm-charts/commit/5aebed0a9b99d75947835981dc6591133d84f6bb))

# [2.21.0](https://github.com/nullplatform/helm-charts/compare/2.20.0...2.21.0) (2025-11-04)


### Features

* **aro:** disambiguate ingresses for internal/external ([0c50c5c](https://github.com/nullplatform/helm-charts/commit/0c50c5c2088d2e12ae882916cabca6eb75ac893d))

# [2.20.0](https://github.com/nullplatform/helm-charts/compare/2.19.0...2.20.0) (2025-11-04)


### Features

* **base:** add SecurityContextConstraints to ARO ([3a2a258](https://github.com/nullplatform/helm-charts/commit/3a2a258c60cf0c320cc057fe4d025c56e84596f7))

# [2.19.0](https://github.com/nullplatform/helm-charts/compare/2.18.0...2.19.0) (2025-11-03)


### Features

* add private controller ([ec76c01](https://github.com/nullplatform/helm-charts/commit/ec76c0197e0e6bb43072d36c05b4b2b291054d04))
* edit values with ingresscontroler ([821945e](https://github.com/nullplatform/helm-charts/commit/821945edd6f9ae9873d8b58677b4de1d0c7de104))

# [2.18.0](https://github.com/nullplatform/helm-charts/compare/2.17.0...2.18.0) (2025-10-30)


### Bug Fixes

* **istio-metrics:** added enabled property to gateway.public ([499db1e](https://github.com/nullplatform/helm-charts/commit/499db1e8a03ba8f2481475dccb9fc8bb496fe7be))
* **istio-metrics:** removed keys ([7cf3504](https://github.com/nullplatform/helm-charts/commit/7cf3504448c78fa54915feed6fdd83e45f4718c6))


### Features

* **base:** Add Istio metrics mode as alternative to log controller ([f2ea251](https://github.com/nullplatform/helm-charts/commit/f2ea25190723d2798975661e52fe0add4d544ecb))
* **base:** remove job ([faa6ee3](https://github.com/nullplatform/helm-charts/commit/faa6ee31b7d251ea4e4dd5e5c91fd00010c95dbd))
* **istio-metrics:** Add Prometheus ConfigMap patching capability ([8c6c279](https://github.com/nullplatform/helm-charts/commit/8c6c27934d2205900dba0bb4181da41a23e25ab0))
* **istio-metrics:** Extract istio metrics into separate chart ([905e115](https://github.com/nullplatform/helm-charts/commit/905e1153939c47aa6e32d2b3cacd968c45676c9d))

# [2.17.0](https://github.com/nullplatform/helm-charts/compare/2.16.1...2.17.0) (2025-10-29)


### Features

* **agent:** Add image pull secret configuration ([4a5efe6](https://github.com/nullplatform/helm-charts/commit/4a5efe6e34c42b026057535ab65886c3f7bdc14f))
* **agent:** Comment out image pull secret credential fields ([533228c](https://github.com/nullplatform/helm-charts/commit/533228c5ac1c09fe203e2627b9e102500616154c))

## [2.16.1](https://github.com/nullplatform/helm-charts/compare/2.16.0...2.16.1) (2025-10-16)


### Bug Fixes

* **base:** Honour nullplatform tools ns configuration ([a6c8740](https://github.com/nullplatform/helm-charts/commit/a6c87405500a37d17613f445157ba060b3d70eea))

# [2.16.0](https://github.com/nullplatform/helm-charts/compare/2.15.0...2.16.0) (2025-10-13)


### Features

* **base:** add annotations for prometheus auto discovery ([be18456](https://github.com/nullplatform/helm-charts/commit/be18456429275fcf84d51da239600aac617ccb1a))
* **base:** make prometheus port annotation configurable ([a8ec8da](https://github.com/nullplatform/helm-charts/commit/a8ec8dad4cc83417bfe81c45cdedf779503b0638))

# [2.15.0](https://github.com/nullplatform/helm-charts/compare/2.14.0...2.15.0) (2025-10-06)


### Features

* make gateway annotations cloud-aware with loadBalancerType flag ([38d41c7](https://github.com/nullplatform/helm-charts/commit/38d41c7e3dbe45f736981e6e7ecfa9a626534a4a))

# [2.14.0](https://github.com/nullplatform/helm-charts/compare/2.13.1...2.14.0) (2025-10-02)


### Features

* edit secret of cloudflare for cert-manager cluster issuer ([a62055d](https://github.com/nullplatform/helm-charts/commit/a62055dbc2447ac0fc3ff84323a4b769f191eb94))

## [2.13.1](https://github.com/nullplatform/helm-charts/compare/2.13.0...2.13.1) (2025-10-01)


### Bug Fixes

* **base:** resolve installGatewayV2Crd serviceaccount timing issue ([c9d697f](https://github.com/nullplatform/helm-charts/commit/c9d697f52f766a01278d1fc9f8144d4fc3bf7a7d))

# [2.13.0](https://github.com/nullplatform/helm-charts/compare/2.12.0...2.13.0) (2025-10-01)


### Features

* add config for cloudflare ([bd6e62d](https://github.com/nullplatform/helm-charts/commit/bd6e62d8805631e2d967d7712d28a5419620a8a7))
* **agent:** fix configMap ([74cfd95](https://github.com/nullplatform/helm-charts/commit/74cfd9531805a84ab1a2af587853c2f5ffe8e1e5))
* **base:** GIT-0000 Improve service account configuration for hooks ([8f00eee](https://github.com/nullplatform/helm-charts/commit/8f00eeeefe8e90b236051e2a7b2a69e61c46e141))
* edit values cert manager config ([330f3dd](https://github.com/nullplatform/helm-charts/commit/330f3dd7d7db2ad249c3ef03c142d7088f24d7d8))
* **helm-charts:** add semantic-release ([e472317](https://github.com/nullplatform/helm-charts/commit/e4723170f09ba7d653ff155a90e571e82850f546))

# [2.12.0](https://github.com/nullplatform/helm-charts/compare/2.11.0...2.12.0) (2025-09-19)


### Features

* add secret and referent in clusterissuer ([a9d5d10](https://github.com/nullplatform/helm-charts/commit/a9d5d105581ce980f20d24dd3818730d10fe2fc0))
* **agent:** [main] add init scripts ([d649fe9](https://github.com/nullplatform/helm-charts/commit/d649fe932952054289e84f01a62aad699c1426b1))
* **agent:** [main] independent deployment ([0695f5c](https://github.com/nullplatform/helm-charts/commit/0695f5c6e5ba0ad8d06b6478ee91dbf77b49da95))
* **agent:** [main] independent deployment ([8d28618](https://github.com/nullplatform/helm-charts/commit/8d2861834a33006d12208597d155faed45448988))
* **agent:** add configmap to initScript ([49e7942](https://github.com/nullplatform/helm-charts/commit/49e79423f6d5d99b6b9f491e873bb86f15a64b53))
* **agent:** add init scripts ([cf4179e](https://github.com/nullplatform/helm-charts/commit/cf4179ed21f8e77039d55b7489eb9c4d918cc6b4))
* **agent:** add init scripts ([21eb9cb](https://github.com/nullplatform/helm-charts/commit/21eb9cbe0b505666ec6e316744705e3e92291b79))
* **agent:** resolve conflic ([b43e33c](https://github.com/nullplatform/helm-charts/commit/b43e33ca78f27cadd15a320029512b1418a202fb))
* **agent:** resolve conflic ([a00fe85](https://github.com/nullplatform/helm-charts/commit/a00fe85f65a7c93327b4155ccd15d0d42bc66871))
* **agent:** resolve conflic ([710fdbf](https://github.com/nullplatform/helm-charts/commit/710fdbfc3135aeb3fbf04338a2f9dbbf255a6116))
* **agent:** resolve conflic ([d64fcb9](https://github.com/nullplatform/helm-charts/commit/d64fcb99f90a0bb35249323cbf454daa3f7799a9))
* **config:** disable ticket request ([a2c120a](https://github.com/nullplatform/helm-charts/commit/a2c120ab57f432358d5ef8a91afb8307812d76b3))
* **docs:** Improve docs and support install in k3s ([6fb9e58](https://github.com/nullplatform/helm-charts/commit/6fb9e5833a049313be6e138f1dbd71482d42220f))
* **docs:** Improve docs and support install in k3s ([404d3ec](https://github.com/nullplatform/helm-charts/commit/404d3ec5956936fefa6deb92c4910123339605de))
* **docs:** Improve docs and support install in k3s ([e1425f3](https://github.com/nullplatform/helm-charts/commit/e1425f3859522dd9e527a0ea8314da1eb47bc038))
* **docs:** Improve docs and support install in k3s ([3a09c89](https://github.com/nullplatform/helm-charts/commit/3a09c8948c56f503bf4a3568b25231e6f8897d4d))
* edit readme, values and secret for azure ([eb361fc](https://github.com/nullplatform/helm-charts/commit/eb361fc1316e7e4095bd90a21a0f20335c6eb5b1))

# [2.11.0](https://github.com/nullplatform/helm-charts/compare/2.10.0...2.11.0) (2025-09-11)


### Features

* add secret and referent in clusterissuer ([fe6e6c7](https://github.com/nullplatform/helm-charts/commit/fe6e6c719562bd573d8609ae7974527914d6143e))
* edit readme, values and secret for azure ([417761d](https://github.com/nullplatform/helm-charts/commit/417761daac198d8a1e102f35bf9bb59b6e9bd1da))

# [2.10.0](https://github.com/nullplatform/helm-charts/compare/2.9.0...2.10.0) (2025-09-08)


### Features

* **agent:** add configmap to initScript ([6aa6c60](https://github.com/nullplatform/helm-charts/commit/6aa6c60d11ab9728f24df15264dc778608290053))

# [2.9.0](https://github.com/nullplatform/helm-charts/compare/2.8.0...2.9.0) (2025-09-04)


### Bug Fixes

* **agnt:** fix conflicts ([6141285](https://github.com/nullplatform/helm-charts/commit/61412854ceb36ad8dcf4e91d4574a1df0e4f1e65))


### Features

* **agent:** [main] independent deployment ([36e50ef](https://github.com/nullplatform/helm-charts/commit/36e50ef57903ec55f9f13e36e25416dbf690a79d))
* **agent:** [main] multiple agent installations ([11e8c62](https://github.com/nullplatform/helm-charts/commit/11e8c6249e79da5f7661f00e4170426a86842fbf))
* **agent:** add init scripts ([9a9c679](https://github.com/nullplatform/helm-charts/commit/9a9c6790a22ae7c4bcd3729f236c31e9359ca92c))
* **base:** add cloudwatch configurations ([1300104](https://github.com/nullplatform/helm-charts/commit/13001046bf3cf49586b1a7dad840a689f649ad4f))
* **config:** disable ticket request ([f168721](https://github.com/nullplatform/helm-charts/commit/f1687214779a02d6b77c61b3ebf47e9107dbf046))

# [2.8.0](https://github.com/nullplatform/helm-charts/compare/2.7.1...2.8.0) (2025-09-03)


### Features

* **config:** disable ticket request ([311bc11](https://github.com/nullplatform/helm-charts/commit/311bc117e6cfea74a4075d57a18be95e8d2d22e9))

## [2.7.1](https://github.com/nullplatform/helm-charts/compare/2.7.0...2.7.1) (2025-08-29)


### Bug Fixes

* **nullplatform-agent:** BAC-1805 add namespace config ([a28d744](https://github.com/nullplatform/helm-charts/commit/a28d7443e5625a5ae3690e566ad6f0f783154d61))

# [2.7.0](https://github.com/nullplatform/helm-charts/compare/2.6.0...2.7.0) (2025-08-28)


### Features

* **nullplatform-agent:** BAC-1805 add nullplatform-agent ([8169add](https://github.com/nullplatform/helm-charts/commit/8169addbe37a65186bd582b5f2ef1817bcd369aa))
* **nullplatform-agent:** BAC-1805 add nullplatform-agent ([259efe4](https://github.com/nullplatform/helm-charts/commit/259efe403c3d76156b6ca50a5e167e8102405a78))

# [2.6.0](https://github.com/nullplatform/helm-charts/compare/2.5.0...2.6.0) (2025-08-21)


### Features

* **agent:** BAC-1773 delete resources req/lim ([0b04906](https://github.com/nullplatform/helm-charts/commit/0b04906567cae50f3b06d0e21e9088699b5fc138))

# [2.5.0](https://github.com/nullplatform/helm-charts/compare/2.4.0...2.5.0) (2025-08-08)


### Features

* **agent:** BAC-1707 update resources req/lim ([6daf2df](https://github.com/nullplatform/helm-charts/commit/6daf2df03c194dbbda3fd57bf04bfc97a3375236))

# [2.4.0](https://github.com/nullplatform/helm-charts/compare/2.3.0...2.4.0) (2025-07-30)


### Features

* **agent:** BAC-1651 add lifecycle ([7240503](https://github.com/nullplatform/helm-charts/commit/7240503a8720f4749f3900730fae033a72c2679a))

# [2.3.0](https://github.com/nullplatform/helm-charts/compare/2.2.0...2.3.0) (2025-07-29)


### Features

* **agent:** BAC-1633 increase request/limit ([eb37de7](https://github.com/nullplatform/helm-charts/commit/eb37de712dc4a3fc801f4852b5e017b0fb80f653))

# [2.2.0](https://github.com/nullplatform/helm-charts/compare/2.1.0...2.2.0) (2025-07-28)


### Features

* **agent:** BAC-1633 refactor command-git ([cc179e4](https://github.com/nullplatform/helm-charts/commit/cc179e4746a3ab77c57cd8b60f6dca60e28d3293))

# [2.1.0](https://github.com/nullplatform/helm-charts/compare/2.0.0...2.1.0) (2025-07-08)


### Features

* **base:** BAC-1546 include resource limits to logs controller containers ([bf6a85e](https://github.com/nullplatform/helm-charts/commit/bf6a85e84d27390e4923f6e0a261015209a9c4c1))

# [2.0.0](https://github.com/nullplatform/helm-charts/compare/1.4.0...2.0.0) (2025-06-19)


### Features

* **base:** NULL-168 added possibility to specify IPs to gateways ([dc022b5](https://github.com/nullplatform/helm-charts/commit/dc022b5a46ae8563978279880e32b4d5fae52b09))


### BREAKING CHANGES

* **base:** no

# [1.4.0](https://github.com/nullplatform/helm-charts/compare/1.3.0...1.4.0) (2025-06-18)


### Features

* **agent:** BAC-1448 add initScript feature ([c2306a1](https://github.com/nullplatform/helm-charts/commit/c2306a138f460125a8aad79e6dc23de5eb200df0))
* **agent:** BAC-1448 final commit ([78eeae1](https://github.com/nullplatform/helm-charts/commit/78eeae1a4c9ce44645b79e382dd1feabacd845ee))

# [1.3.0](https://github.com/nullplatform/helm-charts/compare/1.2.3...1.3.0) (2025-06-10)


### Features

* **agent:** GIT-0000 add configurable initContainers ([6cd41e2](https://github.com/nullplatform/helm-charts/commit/6cd41e26986b5cc0acb628c1c0fa3b16c9a57909))

## [1.2.3](https://github.com/nullplatform/helm-charts/compare/1.2.2...1.2.3) (2025-06-06)


### Bug Fixes

* **agent:** BAC-1458 imagePullPolicy set to always in the agent ([66b2ee5](https://github.com/nullplatform/helm-charts/commit/66b2ee5daf351f2c30ce01969578ff93c0205361))

## [1.2.2](https://github.com/nullplatform/helm-charts/compare/1.2.1...1.2.2) (2025-06-04)


### Bug Fixes

* **base:** BAC-1446 keep gateways on chart deletion and prevent creation if they are already created ([2a1e5eb](https://github.com/nullplatform/helm-charts/commit/2a1e5ebabd8bd970649120f48f4a6881c81873c9))

## [1.2.1](https://github.com/nullplatform/helm-charts/compare/1.2.0...1.2.1) (2025-05-29)


### Bug Fixes

* **agent:** BAC-1406 rename agents chart ([c6187c6](https://github.com/nullplatform/helm-charts/commit/c6187c64ef7e2fdf779733427736b7b42ae96dff))

# [1.2.0](https://github.com/nullplatform/helm-charts/compare/1.1.0...1.2.0) (2025-05-29)


### Features

* **agent:** BAC-1406 added agent chart ([e895501](https://github.com/nullplatform/helm-charts/commit/e895501535265579551da16c8d605eb7498782dd))

# [1.1.0](https://github.com/nullplatform/helm-charts/compare/1.0.0...1.1.0) (2025-05-20)


### Features

* **base:** NULL-147 use nullplatform apikey or provide a secret with the value inside ([30acb5c](https://github.com/nullplatform/helm-charts/commit/30acb5ce29ad03a909dd828525869a6087ae41c8))

# [1.0.0](https://github.com/nullplatform/helm-charts/compare/0.0.22...1.0.0) (2025-04-25)


### Features

* **base:** BAC-1276 semantic versioning enabled ([3848265](https://github.com/nullplatform/helm-charts/commit/3848265368d93299230d70682a2976d573ec9c92))


### BREAKING CHANGES

* **base:** We bump to major version

## [0.0.22](https://github.com/nullplatform/helm-charts/compare/0.0.21...0.0.22) (2025-04-25)


### Bug Fixes

* **config:** BAC-1276 added channel ([6342736](https://github.com/nullplatform/helm-charts/commit/634273673f7a2796347e7598db1b102911e7ab6d))
* **config:** BAC-1276 added channel ([17299cf](https://github.com/nullplatform/helm-charts/commit/17299cffa49925470b211dd9d8fa62811e00b792))
* **config:** BAC-1276 adding validations for releasing chart versions ([e4049b4](https://github.com/nullplatform/helm-charts/commit/e4049b401fbdad920a55b4e1b1f6c46e7b1eddc1))
* **config:** BAC-1276 change release title and state ([b96ad9f](https://github.com/nullplatform/helm-charts/commit/b96ad9f240c12495288603239092b5d5152f3baf))
* **config:** BAC-1276 removed comment ([e183270](https://github.com/nullplatform/helm-charts/commit/e18327093f9a928229e48ff09979ff8f8583ab75))
* **config:** BAC-1276 testing a fix so that bumps charts ([320414d](https://github.com/nullplatform/helm-charts/commit/320414dc3430a6cb0ffeb1691c72ee2add2a2a64))
* **config:** BAC-1276 testing one more ([1c266f9](https://github.com/nullplatform/helm-charts/commit/1c266f925665211627d77293d48707f0f9c251c1))
* **config:** BAC-1276 testing prerelease ([6328845](https://github.com/nullplatform/helm-charts/commit/6328845ee47dd33b6d8ef8ea9997d3332485ab88))
* **config:** BAC-1276 update branch ([b3cc601](https://github.com/nullplatform/helm-charts/commit/b3cc601bf27d4ad39c0242e1f12f288becb49676))

## [0.0.22](https://github.com/nullplatform/helm-charts/compare/0.0.21...0.0.22) (2025-04-25)


### Bug Fixes

* **config:** BAC-1276 added channel ([6342736](https://github.com/nullplatform/helm-charts/commit/634273673f7a2796347e7598db1b102911e7ab6d))
* **config:** BAC-1276 added channel ([17299cf](https://github.com/nullplatform/helm-charts/commit/17299cffa49925470b211dd9d8fa62811e00b792))
* **config:** BAC-1276 adding validations for releasing chart versions ([e4049b4](https://github.com/nullplatform/helm-charts/commit/e4049b401fbdad920a55b4e1b1f6c46e7b1eddc1))
* **config:** BAC-1276 change release title and state ([b96ad9f](https://github.com/nullplatform/helm-charts/commit/b96ad9f240c12495288603239092b5d5152f3baf))
* **config:** BAC-1276 removed comment ([e183270](https://github.com/nullplatform/helm-charts/commit/e18327093f9a928229e48ff09979ff8f8583ab75))
* **config:** BAC-1276 testing a fix so that bumps charts ([320414d](https://github.com/nullplatform/helm-charts/commit/320414dc3430a6cb0ffeb1691c72ee2add2a2a64))
* **config:** BAC-1276 testing one more ([1c266f9](https://github.com/nullplatform/helm-charts/commit/1c266f925665211627d77293d48707f0f9c251c1))
* **config:** BAC-1276 testing prerelease ([6328845](https://github.com/nullplatform/helm-charts/commit/6328845ee47dd33b6d8ef8ea9997d3332485ab88))
* **config:** BAC-1276 update branch ([b3cc601](https://github.com/nullplatform/helm-charts/commit/b3cc601bf27d4ad39c0242e1f12f288becb49676))

## [0.0.22](https://github.com/nullplatform/helm-charts/compare/0.0.21...0.0.22) (2025-04-25)


### Bug Fixes

* **config:** BAC-1276 added channel ([e8bfa0c](https://github.com/nullplatform/helm-charts/commit/e8bfa0c5088d8413b3c4a3dc9e5b0b0b580729d0))
* **config:** BAC-1276 added channel ([2d6538d](https://github.com/nullplatform/helm-charts/commit/2d6538d4203752f975fe00b0c2459098ccbe38c5))
* **config:** BAC-1276 adding validations for releasing chart versions ([d6b5904](https://github.com/nullplatform/helm-charts/commit/d6b5904ffb0063a9b53ca178cc7d16c41d29f628))
* **config:** BAC-1276 change release title and state ([fe86702](https://github.com/nullplatform/helm-charts/commit/fe867020b3688954635e0c6257cb8e46058a6fe0))
* **config:** BAC-1276 removed comment ([640db40](https://github.com/nullplatform/helm-charts/commit/640db40adbd899ce7a7f14a4d3fd20e8c8af3d98))
* **config:** BAC-1276 testing a fix so that bumps charts ([ebf45ff](https://github.com/nullplatform/helm-charts/commit/ebf45ff7d4fe010542cc38666655709467745fb1))
* **config:** BAC-1276 testing one more ([cab390c](https://github.com/nullplatform/helm-charts/commit/cab390c78b32575cc8fe99e3462ed5bd4962a840))
* **config:** BAC-1276 testing prerelease ([57d45f8](https://github.com/nullplatform/helm-charts/commit/57d45f88f5ff0a7e9ebcd371c7bd4fbe347ccb67))
* **config:** BAC-1276 update branch ([ea25cac](https://github.com/nullplatform/helm-charts/commit/ea25cac472b179256422ad19d99b480c3c12a502))

## [0.0.22](https://github.com/nullplatform/helm-charts/compare/0.0.21...0.0.22) (2025-04-25)


### Bug Fixes

* **config:** BAC-1276 added channel ([e8bfa0c](https://github.com/nullplatform/helm-charts/commit/e8bfa0c5088d8413b3c4a3dc9e5b0b0b580729d0))
* **config:** BAC-1276 added channel ([2d6538d](https://github.com/nullplatform/helm-charts/commit/2d6538d4203752f975fe00b0c2459098ccbe38c5))
* **config:** BAC-1276 adding validations for releasing chart versions ([d6b5904](https://github.com/nullplatform/helm-charts/commit/d6b5904ffb0063a9b53ca178cc7d16c41d29f628))
* **config:** BAC-1276 change release title and state ([fe86702](https://github.com/nullplatform/helm-charts/commit/fe867020b3688954635e0c6257cb8e46058a6fe0))
* **config:** BAC-1276 removed comment ([640db40](https://github.com/nullplatform/helm-charts/commit/640db40adbd899ce7a7f14a4d3fd20e8c8af3d98))
* **config:** BAC-1276 testing a fix so that bumps charts ([ebf45ff](https://github.com/nullplatform/helm-charts/commit/ebf45ff7d4fe010542cc38666655709467745fb1))
* **config:** BAC-1276 testing one more ([cab390c](https://github.com/nullplatform/helm-charts/commit/cab390c78b32575cc8fe99e3462ed5bd4962a840))
* **config:** BAC-1276 testing prerelease ([57d45f8](https://github.com/nullplatform/helm-charts/commit/57d45f88f5ff0a7e9ebcd371c7bd4fbe347ccb67))
* **config:** BAC-1276 update branch ([ea25cac](https://github.com/nullplatform/helm-charts/commit/ea25cac472b179256422ad19d99b480c3c12a502))

## [0.0.27](https://github.com/nullplatform/helm-charts/compare/0.0.26...0.0.27) (2025-04-23)


### Bug Fixes

* **config:** BAC-1276 added channel ([6b1c63e](https://github.com/nullplatform/helm-charts/commit/6b1c63ec60892605c5e4b9368a789723e0eb4e3c))

## [0.0.26](https://github.com/nullplatform/helm-charts/compare/0.0.25...0.0.26) (2025-04-23)


### Bug Fixes

* **config:** BAC-1276 added channel ([3091247](https://github.com/nullplatform/helm-charts/commit/309124761f7750a6a56ec02c0ba37be7712f20f6))

## [0.0.25](https://github.com/nullplatform/helm-charts/compare/0.0.24...0.0.25) (2025-04-23)


### Bug Fixes

* **config:** BAC-1276 testing one more ([14f4771](https://github.com/nullplatform/helm-charts/commit/14f47717bc2d708279c9b70f1fb6d78fc9dfd693))

## [0.0.24](https://github.com/nullplatform/helm-charts/compare/0.0.23...0.0.24) (2025-04-23)


### Bug Fixes

* **config:** BAC-1276 testing prerelease ([114dc20](https://github.com/nullplatform/helm-charts/commit/114dc209c98ea331c8927e17262f289eaeddf1e8))

## [0.0.23](https://github.com/nullplatform/helm-charts/compare/0.0.22...0.0.23) (2025-04-23)


### Bug Fixes

* **config:** BAC-1276 change release title and state ([b5c4c13](https://github.com/nullplatform/helm-charts/commit/b5c4c13986358cafc182d2becc8309c17d270093))
* **config:** BAC-1276 removed comment ([ffcbc97](https://github.com/nullplatform/helm-charts/commit/ffcbc97bb17bc0655702e48e80f179fafa026639))
* **config:** BAC-1276 update branch ([6b369b4](https://github.com/nullplatform/helm-charts/commit/6b369b4a73830933ce3aa5334e0eb64298b90bed))

## [0.0.23](https://github.com/nullplatform/helm-charts/compare/0.0.22...0.0.23) (2025-04-23)


### Bug Fixes

* **config:** BAC-1276 change release title and state ([b5c4c13](https://github.com/nullplatform/helm-charts/commit/b5c4c13986358cafc182d2becc8309c17d270093))
* **config:** BAC-1276 removed comment ([ffcbc97](https://github.com/nullplatform/helm-charts/commit/ffcbc97bb17bc0655702e48e80f179fafa026639))
* **config:** BAC-1276 update branch ([6b369b4](https://github.com/nullplatform/helm-charts/commit/6b369b4a73830933ce3aa5334e0eb64298b90bed))

## [0.0.23](https://github.com/nullplatform/helm-charts/compare/0.0.22...0.0.23) (2025-04-23)


### Bug Fixes

* **config:** BAC-1276 change release title and state ([b5c4c13](https://github.com/nullplatform/helm-charts/commit/b5c4c13986358cafc182d2becc8309c17d270093))
* **config:** BAC-1276 removed comment ([ffcbc97](https://github.com/nullplatform/helm-charts/commit/ffcbc97bb17bc0655702e48e80f179fafa026639))

## [0.0.22](https://github.com/nullplatform/helm-charts/compare/0.0.21...0.0.22) (2025-04-23)


### Bug Fixes

* **config:** BAC-1276 adding validations for releasing chart versions ([f9957de](https://github.com/nullplatform/helm-charts/commit/f9957dea279799c2e90f1851ab5437b3be1e8fb0))
* **config:** BAC-1276 testing a fix so that bumps charts ([5a24886](https://github.com/nullplatform/helm-charts/commit/5a2488672fcd4df7ee28b7c618c7f4b1db22879a))
