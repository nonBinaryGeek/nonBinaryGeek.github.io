---
sort: 1
---

# DHCPv4

The configuration of a DHCP server under Ubuntu/Debian can be achieved with the [isc-dhcp-server](https://packages.debian.org/isc-dhcp-server) package. This documentations is only centralizing information in an attempt to propose a basic DHCP Server configuration. For more explanations about what DHCP is and why use it, you can check out the following links or google it like I did.

- [Wikipedia](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol)

- [Microsoft](https://docs.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-top)

- [Cisco](https://study-ccna.com/configure-cisco-router-as-dhcp-server/)

  

With that being said, you can install the previously mentioned package, either on Ubuntu or Debian.

```shell
sudo apt install isc-dhcp-server -y
```

The main configuration file for the dhcp server can be found at /etc/dhcp/dhcpd.conf
Also, since Linux treat this package as a service, you should use systemd for administration purpose. To check the actual status of the server, use the following command :

```shell
sudo systemctl status isc-dhcp-server
```

You can also enable the server by using the enable statement

```shell
sudo systemctl enable isc-dhcp-server
```

And as a brief reminder :

```shell
sudo service isc-dhcp-server.service stop
```

```shell
sudo service isc-dhcp-server.service start
```

```shell
sudo service isc-dhcp-server.service restart
```

```shell
sudo systemctl reload isc-dhcp-server
```

```shell
sudo systemctl disable isc-dhcp-server
```



## Setting up your network interface-s

Before we messed the configuration, we should properly configure our system network interfaces. These can be found under /etc/network/interfaces

```shell
sudo nano /etc/network/interfaces
```

```
auto lo
iface lo inet loopback

mapping hotplug
        script grep
        map eth1

iface eth1 inet dhcp

auto ens33
iface ens33 inet static
    address 10.152.187.50
    netmask 255.255.255.0

auto wlan0
  iface wlan0 inet static
    address 192.168.1.1
    netmask 255.255.255.0
    up     /sbin/iwconfig wlan0 mode TTTTTT && /sbin/iwconfig wlan0 enc
restricted && /sbin/iwconfig wlan0 key [Y] XXXXXXXX && /sbin/iwconfig
wlan0 essid SSSSSSSS

auto eth1
```

> The above file is just an example. What is important to understand here is the possibility we have to configure static interfaces associated with a specified IP address. To configure a static interface, the same formulation as stated above for `ens33` should be used.

If you edit something in your `interfaces` file, you should restart your networking service before continuing.

```shell
sudo systemctl restart networking
```

To see if the interface you modified has the right configuration, you can use the `ip` command.

```shell
ip a
```

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth1: <BROADCAST,MULTICAST,DOWN,MASTER> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether aa:36:95:78:f9:c5 brd ff:ff:ff:ff:ff:ff
3: ens33: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:e7:6b:a0 brd ff:ff:ff:ff:ff:ff
    inet  10.152.187.50/24 brd 10.152.187.255 scope global ens33
       valid_lft forever preferred_lft forever
    inet6 fe80::215:5dff:fee7:6ba0/64 scope link
       valid_lft forever preferred_lft forever
```



## Configuration

As stated previously, main configuration file is under /etc/dhcp/dhcpd.conf

```shell
sudo nano /etc/dhcp/dhcpd.conf
```

```
ddns-update-style none;
log-facility local7;

subnet 192.168.1.0 netmask 255.255.255.0 {

        option routers                  192.168.1.1;
        option subnet-mask              255.255.255.0;
        option broadcast-address        192.168.1.255;
        option domain-name-servers      194.168.4.100;
        option ntp-servers              192.168.1.1;
        option netbios-name-servers     192.168.1.1;
        option netbios-node-type 2;
        default-lease-time 86400;
        max-lease-time 86400;

        host blablabla1 {
                hardware ethernet DD:GH:DF:E5:F7:D7;
                fixed-address 192.168.1.2;
        }
        host blablabla2 {
                hardware ethernet 00:JJ:YU:38:AC:45;
                fixed-address 192.168.1.20;
        }
}

subnet  10.152.187.0 netmask 255.255.255.0 {

        option routers                  10.152.187.1;
        option subnet-mask              255.255.255.0;
        option broadcast-address        10.152.187.255;
        option domain-name-servers      194.168.4.100;
        option ntp-servers              10.152.187.1;
        option netbios-name-servers     10.152.187.1;
        option netbios-node-type 2;

        default-lease-time 86400;
        max-lease-time 86400;

        host bla3 {
                hardware ethernet 00:KK:HD:66:55:9B;
                fixed-address 10.152.187.2;
        }
}
```

> Again, this is an example. You should modify your configuration file depending on your network requirements and actual network interfaces.

When setting up a DHCP service, one of the most useful command you can use is  `ip route`. It makes it real easy to actually see if our config is effective.

```shell
ip route
```

```
192.168.1.0/24 dev wlan0  scope link
82.16.TT.0/24 dev eth1  scope link
10.152.187.0/24 dev eth0  scope link
default via 82.16.TT.UU dev eth1
```







