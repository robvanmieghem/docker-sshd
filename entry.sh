#!/usr/bin/env bash

set -e


# Generate Host keys, if required
if [ ! -f /etc/ssh/ssh_host_* ]; then
        ssh-keygen -A
fi

mkdir -p /root/.ssh
echo $1 > /root/.ssh/authorized_keys

chmod 700 ~/.ssh/ && chmod 600 ~/.ssh/*


stop() {
    echo "Received SIGINT or SIGTERM. Shutting down $DAEMON"
    # Get PID
    pid=$(cat /var/run/sshd/sshd.pid)
    # Set TERM
    kill -SIGTERM "${pid}"
    # Wait for exit
    wait "${pid}"
}

echo "Starting sshd"
trap stop SIGINT SIGTERM
# Log to the stdout of process with id 1 (this script since it is the entrypoint in the docker)
# This way the sshd logs show up in the container logs
/usr/sbin/sshd -D -E /proc/$$/fd/1 &
pid="$!"
mkdir -p /var/run/sshd && echo "${pid}" > /var/run/sshd/sshd.pid
wait "${pid}" && exit $?
