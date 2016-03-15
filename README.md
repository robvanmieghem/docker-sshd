# docker-sshd

Small utility docker that runs an sshd to easily access other containers.

Usage:

Expose port 22 of the docker on the host and pass a public key as commandparameter, it will be added to the root users authorized keys.

Example:

```
docker run --rm -p 1234:22 robvanmieghem/sshd "ssh-rsa ABBB...BBBBBBBB$BBBB...anAB rob@rob.local"
```
