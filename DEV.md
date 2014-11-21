# Docker, dig, consul

This is a description on how to use [Consul](https://www.consul.io) in Docker so that it can serv other containers,
as a DNS server.

## start consul

To start a consul container locally on boot2docker:
```
BRIDGE_IP=$(docker run --rm debian:jessie ip ro | grep default | cut -d" " -f 3)
docker run -d \
  -h node1 \
  --name=consul \
  -p ${BRIDGE_IP}:53:53/udp 
  sequenceiq/consul:v0.4.1.ptr -server -bootstrap
```

## Using consul as dns server in containers

Now you can start other containers which uses consul as DNS server 
```
docker run -it --rm \
  --dns=$BRIDGE_IP \
  --dns=8.8.8.8 \
  --dns-search=node.consul \
  --dns-search=service.consul 
  debian:jessie
```

If you want that all future containers use the dns and dns-search settings, you have to add the 
following options to docker daemon:
`--dns=<BRIDGE_IP> --dns=8.8.8.8 --dns-search=node.consul --dns-search=service.consul`

For boot2docker you can use the `EXTRA_ARGS` env variable in `/var/lib/boot2docker/profile`. Instead of
hand editing, here is the one-liner:
```
boot2docker ssh sudo "sed '$ a\EXTRA_ARGS=\"\$EXTRA_ARGS --dns=$BRIDGE_IP --dns=8.8.8.8 --dns-search=node.consul --dns-search=service.consul\"' /var/lib/boot2docker/profile"
boot2docker restart
```

## Understanding /etc/resolv.conf

```
nameserver 172.19.0.1
search node.consul service.consul
```

when not specified otherwise cli tools like: `dig`, `host`, `nslookup` will talk to **nameserver**.
If you want to spare a couple of keystrokes, You can define the **search** domains, they will be appended to
the short name

```
$ nslookup consul
Server:         172.19.0.1
Address:        172.19.0.1#53

Name:   consul.service.consul
Address: 172.19.0.18
```

dig doesn't honors **search** domanis by default, you have to force it with the `+search` option

```
$ dig +search consul +short
172.19.0.18
```

## dig aliases

The firs alias to show **query** and **answer** sections only.
The second alias produces the minimal output (cli-fu) with dns-search enabled.
```
alias digq='dig +search +nocmd +noall +answer +que'
alias digs='dig +search +short'
```

