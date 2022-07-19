# Installing plutus playground using Docker container
## Overview
This guide will show you how to compile and install plutus playground` using Docker container, directly from the source-code.

```
DOCKER_BUILDKIT=1 docker build --build-arg GIT_COMMIT=41149926c108c71831cfe8d244c83b0ee4bf5c8a -t plutus-playground .
```

```
docker run -d -p 8009:8009 plutus-playground
```

## Plutus Playground
```
http://localhost:8009/
```