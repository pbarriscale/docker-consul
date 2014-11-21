
To start a consul container locally on boot2docker:

```
BRIDGE_IP=$()
docker run -d -h node1 --name=consul -p ${BRIDGE_IP}:53:53/udp sequenceiq/consul:v0.4.1.ptr -server -bootstrap

```

## dig

dig command alias to show **query** and **answer** sections only
```
alias dd='dig +serach +nocmd +noall +answer +que'
```

dig command alias tp produce the minimal output (cli-fu)
```
alias d='dig +serach +short'
```

## /etc/resolv.conf

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
