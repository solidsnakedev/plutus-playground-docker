# Installing plutus playground using Docker container
## Overview
This guide will show you how to compile and install plutus playground` using Docker container, directly from the source-code.

## 1. Copy one of the git commits

| **Weeks** | **Git commits**                          |
|-----------|------------------------------------------|
| Week01    | 41149926c108c71831cfe8d244c83b0ee4bf5c8a |
| Week02    | 6aff97d596ac9d59460aab5c65627b1c8c0a1528 |
| Week03    | 4edc082309c882736e9dec0132a3c936fe63b4ea |
| Week04    | ea1bfc6a49ee731c67ada3bfb326ee798001701a |
| Week05    | 62efdd2bfab3e076d40e07f8f4d7864a7f2ccc91 |
| Week06    | 6e3f6a59d64f6d4cd9d38bf263972adaf4f7b244 |
| Week07    | 13836ecf59649ca522471417b07fb095556eb981 |
| Week08    | c9c1e917edbfa3b972c92108d7b94d5430e07a28 |
| Week09    | 400318e0976b82e0ba7692edf26d93293589c671 |
| Week10    | 14bed17e8608162ee81969e482c1815fb78bd7b0 |

*Note: commits are taken from cabal project file of each week*

*Please refer to the following link as an example:*

https://github.com/input-output-hk/plutus-pioneer-program/blob/main/code/week01/cabal.project

![Alt text](./cabal-project-example.png)

## 2. Building plutus playground image
*Here we copied week01 `41149926c108c71831cfe8d244c83b0ee4bf5c8a`*
```
DOCKER_BUILDKIT=1 docker build --build-arg GIT_COMMIT=41149926c108c71831cfe8d244c83b0ee4bf5c8a -t plutus-playground .
```

## 3. Running container

```
docker run -d -p 8009:8009 plutus-playground
```

## 4. Plutus Playground website

http://localhost:8009/
