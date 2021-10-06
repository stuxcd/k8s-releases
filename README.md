# Dockerfiles 
[![dockerfiles-master Actions Status](https://github.com/josh9398/dockerfiles/workflows/dockerfiles-master/badge.svg)](https://github.com/josh9398/dockerfiles/actions)

Accumulating useful charts and images

## Requirements

Add the helm repo

```bash
helm repo add stuxcd https://stuxcd.github.io/k8s-releases
helm repo update

helm repo search stuxcd
```

## Debug-shed

Swiss army knife for container network testing. Useful when deploying to k8s.

### Helm with:

```bash
helm install debug-shed stuxcd/debug-shed -n debug-system
```

### Docker with:

```bash
docker run -it josh9398/debug-shed
```

## Alpine curl

Useful for curl command testing.

### Run with:

```bash
docker run -d -t josh9398/alpine-curl
```

## Jenkins master

Jenkins master with plugins installed for bare metal deployments in air gapped network.

### Run with:

```bash
docker run -d -p 8080:8080 -p 50000:50000 josh9398/jenkins
```

## S3FS

Useful as a sidecar container in kubernetes or compose. 

It mounts an S3 bucket that can be propogated to other containers as a shared volume.

Note this requires elevated privileges `--privileged=true` or at a minimum `--cap-add mknod --cap-add sys_admin --device=/dev/fuse`

### Run with:

```bash
docker run -d --privileged -e S3_BUCKET="bucketname" -e S3_ENDPOINT="https://s3.amazonaws.com" -e AWS_ACCESS_KEY_ID="xxxx" -e AWS_SECRET_ACCESS_KEY="xxxx" josh9398/s3fs
```

### K8 manifest

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: my-statefulset
  labels:
    some.interesting.labels: wow
spec:
  replicas: 1
  serviceName: my-statefulset
  selector:
    matchLabels:
      some.interesting.labels: wow
  template:
    metadata:
      labels:
        some.interesting.labels: wow
    spec:
      containers:
        - name: nginx
          image: nginx
          volumeMounts:
            - name: s3-shared
              mountPath: /var/www/
              mountPropagation: HostToContainer         
        - name: s3fs
          image: your.built.s3fs.image:tag
          securityContext:
            privileged: true    
          env:
            - name: AWS_ACCESS_KEY_ID
              value: "<your access key>"
            - name: AWS_SECRET_ACCESS_KEY
              value: "<your secret key>"
            - name: S3_BUCKET
              value: "<your bucket name>"
            - name: MNT_POINT
              value: "/mnt"
            - name: S3_ENDPOINT
              value: "<http://your.s3.endpoint:port>"
          volumeMounts:
            - name: s3-shared
              mountPath: /mnt
              mountPropagation: Bidirectional
      volumes:
      - name: s3-shared
        emptyDir: {}
```

## Wait for it

Uses [vishnubob's](https://github.com/vishnubob/wait-for-it) wait for it script in docker. 

```yaml
version: '3'

networks:
  integration-tests:
    driver: bridge

services:
  awesome-app:
    image: your/awesome-app
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: root
      POSTGRES_DB: test
    depends_on:
      - wait
    networks:
      - integration-tests
  db:
    image: postgres:11.1
    ports:
      - "5432:5432"
    expose:
      - "5432"
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: root
      POSTGRES_DB: test
    restart: on-failure
    networks:
      - integration-tests
  wait:
    image: josh9398/wait-for-it
    command: ["db:5432"]
    depends_on:
      - db
    networks:
      - integration-tests
```
Then test with:
```bash
docker-compose up --exit-code-from awesome-app
```

## DockerHub

Link to images on DockerHub [here](https://hub.docker.com/u/josh9398)
