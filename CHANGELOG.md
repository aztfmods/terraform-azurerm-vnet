# Changelog

## [1.17.0](https://github.com/aztfmods/terraform-azure-vnet/compare/v1.16.0...v1.17.0) (2023-08-14)


### Features

* removed deprecated sdk and tests are now using the new one ([#111](https://github.com/aztfmods/terraform-azure-vnet/issues/111)) ([9a36105](https://github.com/aztfmods/terraform-azure-vnet/commit/9a3610519ea96a999fd48aee7f3956bc86f082b4))


### Bug Fixes

* fix in use networkwork security group can not be deleted using lifecycle property create before destroy on subnets ([#115](https://github.com/aztfmods/terraform-azure-vnet/issues/115)) ([f8a1053](https://github.com/aztfmods/terraform-azure-vnet/commit/f8a10536ba2b5edb6121baf9f75d9b23b3e89f81))

## [1.16.0](https://github.com/aztfmods/terraform-azure-vnet/compare/v1.15.0...v1.16.0) (2023-08-04)


### Features

* add encryption support ([#109](https://github.com/aztfmods/terraform-azure-vnet/issues/109)) ([f6671fb](https://github.com/aztfmods/terraform-azure-vnet/commit/f6671fb965d6a3e70ac7eaeb21cb5e7cd81a3912))
* **deps:** Bump github.com/gruntwork-io/terratest from 0.43.9 to 0.43.11 in /tests ([#107](https://github.com/aztfmods/terraform-azure-vnet/issues/107)) ([43ab200](https://github.com/aztfmods/terraform-azure-vnet/commit/43ab200a5155e765f2d04171fcb5fc9abf2cb199))

## [1.15.0](https://github.com/aztfmods/terraform-azure-vnet/compare/v1.14.0...v1.15.0) (2023-07-26)


### Features

* **deps:** Bump github.com/gruntwork-io/terratest from 0.43.8 to 0.43.9 in /tests ([#103](https://github.com/aztfmods/terraform-azure-vnet/issues/103)) ([2dcee93](https://github.com/aztfmods/terraform-azure-vnet/commit/2dcee93250f5cd95e7e18e57924aafc2c5d88d55))
* grouped related tests together with t.run and specified test helper functions ([#104](https://github.com/aztfmods/terraform-azure-vnet/issues/104)) ([30d341c](https://github.com/aztfmods/terraform-azure-vnet/commit/30d341cc882ba388f6fb1dc65426710495b4acf8))

## [1.14.0](https://github.com/aztfmods/terraform-azure-vnet/compare/v1.13.0...v1.14.0) (2023-07-11)


### Features

* **deps:** bump github.com/gruntwork-io/terratest from 0.43.6 to 0.43.8 in /tests ([#102](https://github.com/aztfmods/terraform-azure-vnet/issues/102)) ([45a4011](https://github.com/aztfmods/terraform-azure-vnet/commit/45a401131e0220fe9f335da9c55ef8b2e72af54f))
* **deps:** bump google.golang.org/grpc from 1.51.0 to 1.53.0 in /tests ([#101](https://github.com/aztfmods/terraform-azure-vnet/issues/101)) ([aa6b0e9](https://github.com/aztfmods/terraform-azure-vnet/commit/aa6b0e9d49c146aebb0feba709ac1faac9e75775))
* fix linting issues ([#99](https://github.com/aztfmods/terraform-azure-vnet/issues/99)) ([209f6c5](https://github.com/aztfmods/terraform-azure-vnet/commit/209f6c592636f1a8b7830b294eba5894c35cd3d7))

## [1.13.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.12.0...v1.13.0) (2023-06-28)


### Features

* **deps:** bump github.com/gruntwork-io/terratest in /tests ([#98](https://github.com/aztfmods/module-azurerm-vnet/issues/98)) ([77b9301](https://github.com/aztfmods/module-azurerm-vnet/commit/77b930185a0bdfe15acddd015e35b5a48e14a82f))
* randomize naming abit ([#96](https://github.com/aztfmods/module-azurerm-vnet/issues/96)) ([f8d3ae7](https://github.com/aztfmods/module-azurerm-vnet/commit/f8d3ae7b0139362858412ff4d584ec4e9e7e0536))

## [1.12.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.11.0...v1.12.0) (2023-06-09)


### Features

* enhanced error message handling in tests ([#94](https://github.com/aztfmods/module-azurerm-vnet/issues/94)) ([d16d29a](https://github.com/aztfmods/module-azurerm-vnet/commit/d16d29a133afcd1388d987a2321ec5f7d0bcebeb))

## [1.11.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.10.0...v1.11.0) (2023-04-29)


### Features

* refactor tests to use shared package ([#83](https://github.com/aztfmods/module-azurerm-vnet/issues/83)) ([0eca6e5](https://github.com/aztfmods/module-azurerm-vnet/commit/0eca6e52687617c4b6ecb08d5949e67502afdb40))

## [1.10.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.9.0...v1.10.0) (2023-04-04)


### Features

* improved test verbosity to provide more detailed output ([#75](https://github.com/aztfmods/module-azurerm-vnet/issues/75)) ([aefa2d4](https://github.com/aztfmods/module-azurerm-vnet/commit/aefa2d4f55a4f30e361e6e30e6626cd0839a5a7e))

## [1.9.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.8.1...v1.9.0) (2023-04-02)


### Features

* improved cleanup function, which is used after testing ([#72](https://github.com/aztfmods/module-azurerm-vnet/issues/72)) ([05ad628](https://github.com/aztfmods/module-azurerm-vnet/commit/05ad628c24b532b1f00a52ae2eac9ac0a6d62c1c))

## [1.8.1](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.8.0...v1.8.1) (2023-02-26)


### Bug Fixes

* because of api limitations forced a sequential destroy ([#62](https://github.com/aztfmods/module-azurerm-vnet/issues/62)) ([71c8bc2](https://github.com/aztfmods/module-azurerm-vnet/commit/71c8bc29cd28c8bce3d37a1f6098eee88a6d9e7f))

## [1.8.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.7.0...v1.8.0) (2023-02-24)


### Features

* add nsg associations testing ([#61](https://github.com/aztfmods/module-azurerm-vnet/issues/61)) ([30f0247](https://github.com/aztfmods/module-azurerm-vnet/commit/30f024783621d91f8fe880ee1d9e6217e76aa445))
* simplify structure ([#53](https://github.com/aztfmods/module-azurerm-vnet/issues/53)) ([93751b6](https://github.com/aztfmods/module-azurerm-vnet/commit/93751b6b9c04878b74684d5fc080558451a4e87c))
* update documentation and cleanups ([#59](https://github.com/aztfmods/module-azurerm-vnet/issues/59)) ([ac90fcd](https://github.com/aztfmods/module-azurerm-vnet/commit/ac90fcd1cc836c60a552ada2324e19b243a128d4))

## [1.7.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.6.0...v1.7.0) (2022-12-06)


### Features

* add azurerm_network_security_group example ([#50](https://github.com/aztfmods/module-azurerm-vnet/issues/50)) ([6286167](https://github.com/aztfmods/module-azurerm-vnet/commit/6286167a6917ef2d68c37ce417bce829cb318052))
* add delegation example ([#48](https://github.com/aztfmods/module-azurerm-vnet/issues/48)) ([464cfa5](https://github.com/aztfmods/module-azurerm-vnet/commit/464cfa5ce29d52064538ad23c37a727d6f0233a5))
* add multiple vnets, subnets example ([#51](https://github.com/aztfmods/module-azurerm-vnet/issues/51)) ([9560bec](https://github.com/aztfmods/module-azurerm-vnet/commit/9560becc94e9689363465dae4682674b85059324))
* add service_endpoints example ([#49](https://github.com/aztfmods/module-azurerm-vnet/issues/49)) ([4c7b2b1](https://github.com/aztfmods/module-azurerm-vnet/commit/4c7b2b1ba1857b01b88f6f18ecf405d6ce46476c))
* small refactor naming convention ([#46](https://github.com/aztfmods/module-azurerm-vnet/issues/46)) ([f9ef6d1](https://github.com/aztfmods/module-azurerm-vnet/commit/f9ef6d1aad31a99c7d627c294d3829a9f82e3fce))

## [1.6.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.5.0...v1.6.0) (2022-11-29)


### Features

* add initial config ([#26](https://github.com/aztfmods/module-azurerm-vnet/issues/26)) ([63e3c02](https://github.com/aztfmods/module-azurerm-vnet/commit/63e3c0274ba23b278ef544a96a35bee03c4fd842))


### Bug Fixes

* fix delegation section ([#32](https://github.com/aztfmods/module-azurerm-vnet/issues/32)) ([b22fb32](https://github.com/aztfmods/module-azurerm-vnet/commit/b22fb32a03234dcbe25fb5bbf60c0fdf3cb5efc9))

## [1.5.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.4.0...v1.5.0) (2022-10-11)


### Features

* add consistent naming ([#20](https://github.com/aztfmods/module-azurerm-vnet/issues/20)) ([bbcc3ab](https://github.com/aztfmods/module-azurerm-vnet/commit/bbcc3abcbc3d9c7c24512335ce2db4e00e83c513))
* add ddos protection integration ([#23](https://github.com/aztfmods/module-azurerm-vnet/issues/23)) ([181843a](https://github.com/aztfmods/module-azurerm-vnet/commit/181843abd565786d96e78e11fb4830317cbe7e64))
* add reusable workflows ([#22](https://github.com/aztfmods/module-azurerm-vnet/issues/22)) ([8ddf732](https://github.com/aztfmods/module-azurerm-vnet/commit/8ddf732d4a02ffc2f32296fca6f82960624bfffb))
* update documentation ([#24](https://github.com/aztfmods/module-azurerm-vnet/issues/24)) ([54646f9](https://github.com/aztfmods/module-azurerm-vnet/commit/54646f99b7aa8e742c00de591b094b89a3adb6cd))

## [1.4.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.3.0...v1.4.0) (2022-09-21)


### Features

* add diagnostics integration ([#17](https://github.com/aztfmods/module-azurerm-vnet/issues/17)) ([bfe915c](https://github.com/aztfmods/module-azurerm-vnet/commit/bfe915ca4efbb2ef264e66407b8c6e9552e875ba))
* minor documentation changes ([#19](https://github.com/aztfmods/module-azurerm-vnet/issues/19)) ([8b93209](https://github.com/aztfmods/module-azurerm-vnet/commit/8b93209d935f64dee4fcea77f45e1d3a4219308b))

## [1.3.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.2.0...v1.3.0) (2022-09-20)


### Features

* add initial module ([#1](https://github.com/aztfmods/module-azurerm-vnet/issues/1)) ([dc49b35](https://github.com/aztfmods/module-azurerm-vnet/commit/dc49b35d1189df4b9d05cf4e98f34da24743737e))
* add nsg outputs ([#13](https://github.com/aztfmods/module-azurerm-vnet/issues/13)) ([f2c3b7f](https://github.com/aztfmods/module-azurerm-vnet/commit/f2c3b7f6975793e645f1f2a7ebb392a5a80c72f4))
* add optional dns ([#3](https://github.com/aztfmods/module-azurerm-vnet/issues/3)) ([281a9ae](https://github.com/aztfmods/module-azurerm-vnet/commit/281a9aea7dc68a6e0c15d14c79d89872d78dc081))
* add optional nsg rules ([#5](https://github.com/aztfmods/module-azurerm-vnet/issues/5)) ([de0680c](https://github.com/aztfmods/module-azurerm-vnet/commit/de0680c74ea3e57bc1636d64e4309f6d390ec5f1))
* add validation ([#4](https://github.com/aztfmods/module-azurerm-vnet/issues/4)) ([da753be](https://github.com/aztfmods/module-azurerm-vnet/commit/da753be82333c8c0e548c680e11a8dc1f8b12cf4))
* update documentation ([#6](https://github.com/aztfmods/module-azurerm-vnet/issues/6)) ([943ef6a](https://github.com/aztfmods/module-azurerm-vnet/commit/943ef6abf194659b756f47944fcdc9e5278d399b))


### Bug Fixes

* replace all deprecated arguments ([#8](https://github.com/aztfmods/module-azurerm-vnet/issues/8)) ([25d476e](https://github.com/aztfmods/module-azurerm-vnet/commit/25d476e3b27e8c7a00880438540471fc333d8f11))

## [1.2.0](https://github.com/aztfmods/module-azurerm-vnet/compare/v1.1.1...v1.2.0) (2022-09-19)


### Features

* add nsg outputs ([#13](https://github.com/aztfmods/module-azurerm-vnet/issues/13)) ([f2c3b7f](https://github.com/aztfmods/module-azurerm-vnet/commit/f2c3b7f6975793e645f1f2a7ebb392a5a80c72f4))

## [1.1.1](https://github.com/dkooll/terraform-azurerm-vnet/compare/v1.1.0...v1.1.1) (2022-09-14)


### Bug Fixes

* replace all deprecated arguments ([#8](https://github.com/dkooll/terraform-azurerm-vnet/issues/8)) ([25d476e](https://github.com/dkooll/terraform-azurerm-vnet/commit/25d476e3b27e8c7a00880438540471fc333d8f11))

## [1.1.0](https://github.com/dkooll/terraform-azurerm-vnet/compare/v1.0.0...v1.1.0) (2022-09-10)


### Features

* update documentation ([#6](https://github.com/dkooll/terraform-azurerm-vnet/issues/6)) ([943ef6a](https://github.com/dkooll/terraform-azurerm-vnet/commit/943ef6abf194659b756f47944fcdc9e5278d399b))

## 1.0.0 (2022-09-10)


### Features

* add initial module ([#1](https://github.com/dkooll/terraform-azurerm-vnet/issues/1)) ([dc49b35](https://github.com/dkooll/terraform-azurerm-vnet/commit/dc49b35d1189df4b9d05cf4e98f34da24743737e))
* add optional dns ([#3](https://github.com/dkooll/terraform-azurerm-vnet/issues/3)) ([281a9ae](https://github.com/dkooll/terraform-azurerm-vnet/commit/281a9aea7dc68a6e0c15d14c79d89872d78dc081))
* add optional nsg rules ([#5](https://github.com/dkooll/terraform-azurerm-vnet/issues/5)) ([de0680c](https://github.com/dkooll/terraform-azurerm-vnet/commit/de0680c74ea3e57bc1636d64e4309f6d390ec5f1))
* add validation ([#4](https://github.com/dkooll/terraform-azurerm-vnet/issues/4)) ([da753be](https://github.com/dkooll/terraform-azurerm-vnet/commit/da753be82333c8c0e548c680e11a8dc1f8b12cf4))
