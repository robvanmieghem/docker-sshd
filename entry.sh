#!/usr/bin/env bash

set -e


# Generate Host keys, if required
if [ ! -f /etc/ssh/ssh_host_* ]; then
        ssh-keygen -A
fi

mkdir /root/.ssh
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
/usr/sbin/sshd -D &
pid="$!"
mkdir -p /var/run/sshd && echo "${pid}" > /var/run/sshd/sshd.pid
wait "${pid}" && exit $?