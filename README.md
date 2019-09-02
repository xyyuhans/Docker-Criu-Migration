# Docker Container Migration Depends on CRIU & NFS

Based on [ZhuangweiKang](https://github.com/ZhuangweiKang)/[Docker-CRIU-Live-Migration](https://github.com/ZhuangweiKang/Docker-CRIU-Live-Migration)

Differences:

- I don't know whether it is live migration, so I delete the "live" in the name.
- Delete the kernel part, for I didn't encounter kernel issues.
- Delete the firewall part. If you need firewall, read the origin repo.
- Write shell install for it, including `host.sh` and `client.sh`.
- Update the method to install docker and criu.

Disclaimer: I am not responsible for any damage. Making any modifications to your device is your own choice only! Recommend for reading the shell before executing it.

Prerequests:

  - Two Ubuntu 16.04 servers.

# How it works

1. Install docker and [criu](https://criu.org/Main_Page).
2. Some configurations for docker.
   - Run without sudo.
   - Enable experimental feature to use checkpoint.
3. Install nfs to allow client to mount host. So client can get the checkpoint files from host and restore using these files.
4. Test your migration.

# Steps

1. Install docker

   ```shell
   curl -fsSL get.docker.com | VERSION=17.03.0-ce sh
   ```

   Notes:

   - Install the old version of docker. Some of experimental functions are not included in new version.
   - This shell may not work well on Ubuntu > 16.04.
   - For more information about this shell to install docker, see [this](https://github.com/docker/docker-install/pull/62).

2. Install criu

   ```shell
   sudo apt-get install criu
   ```

3. Configuration

- On the host:

  ```shell
  sudo host.sh
  ```

  Attention:

  1. It will destroy your origin configurations about /etc/exports in your host.

- On the client:

  ```shell
  sudo client.sh
  ```
  
  Notes:
  
  1. Use `df -h` in your client to see whether your host has mounted your client. 
4. Test your live migration

- On the host

```sh
docker run -d --name looper2 --security-opt seccomp:unconfined busybox \
         /bin/sh -c 'i=0; while true; do echo $i; i=$(expr $i + 1); sleep 1; done'

# wait a few seconds to give the container an opportunity to print a few lines, then
docker checkpoint create --checkpoint-dir=/home/ubuntu/Container-Checkpoints/ looper2 checkpoint2

# check your container & print log file
docker ps
docker logs looper2
```
- On the client

```sh
docker create --name looper-clone --security-opt seccomp:unconfined busybox \
         /bin/sh -c 'i=0; while true; do echo $i; i=$(expr $i + 1); sleep 1; done'

docker start --checkpoint-dir=/nfs/home/ubuntu/Container-Checkpoints/ --checkpoint=checkpoint2 looper-clone

# check your container
docker ps
docker logs looper-clone
```
