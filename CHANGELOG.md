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
