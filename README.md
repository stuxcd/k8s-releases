# Dockerfiles 
[![Build Status](https://travis-ci.com/josh9398/dockerfiles.svg?branch=master)](https://travis-ci.com/josh9398/dockerfiles)

Accumulating useful images

## Alpine curl

Useful for curl command testing.

### Run with:

```bash
docker run -d -t josh9398/alpine-curl
```

## Debug-shed

Swiss army knife for container network testing. Useful when deploying to k8s.

### Run with:

```bash
docker run -it josh9398/debug-shed
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

## DockerHub

Link to images on DockerHub [here](https://hub.docker.com/u/josh9398)
