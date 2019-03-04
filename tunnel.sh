#!/bin/sh

rm -rf /root/.ssh && mkdir /root/.ssh && cp -R /root/ssh/* /root/.ssh/ && chmod -R 600 /root/.ssh/*

IFS=','
tunnel_ports=""
for PORT in $PORTS
do
    i=0
    IFS=':'
    for TUNNEL_PORT in $PORT
    do
        i=$(($i+1))
        eval "port${i}=${TUNNEL_PORT}"
    done
    tunnel_ports="$tunnel_ports -L *:${port1}:${BIND_ADDRESS:-127.0.0.1}:${port2:-$port1} "
    unset port1 port2
done
if [[ -z "$USERNAME" ]]
then
    host="$REMOTE_HOST"
else
    host="$USERNAME@$REMOTE_HOST"
fi

echo "$host"

echo "$tunnel_ports"

ssh_cmd="ssh -vv -o StrictHostKeyChecking=no $tunnel_ports -N $host"

echo "$ssh_cmd"
eval "$ssh_cmd"
