---
sort: 2
---



# OpenVPN

> Easy installation with  https://github.com/Nyr/openvpn-install script
>
> In this guide, I’ll show you an easy way to have OpenVPN Server installed on Ubuntu 20.04/18.04/16.04 and ready for clients to start using it. I know OpenVPN setup through a manual process can be challenging especially for new users not experienced with Linux and VPNs.
>
> This method will work well with both Debian family distributions as well as Red Hat family. This guide is specific to Ubuntu 20.04/18.04/16.04, but the setup process will be similar for other distributions. It is a scripted way so anyone with basic Linux knowledge can follow along.
>

**Install and Configure OpenVPN Server on Ubuntu 20.04/18.04/16.04**

## Setup Prerequisites

Before you start installing any package on your Ubuntu server, we always recommend making sure that all system packages are updated

```
sudo apt update -y && sudo apt upgrade -y
```

Once you update the system, we can begin the installation and configuration of OpenVPN server on Ubuntu 20.04/18.04/16.04 system. We will use openvpn-install <https://github.com/Nyr/openvpn-install> script which let you set up your own VPN server in no more than a minute, even if you haven’t used OpenVPN before. It has been designed to be as unobtrusive and universal as possible.

To clone the script from the remote github repository, install the git package

```
sudo apt install git
```



## Clone the script from the remote repo

Clone openvpn-install repository now clone openvpn-install repository using the git command

```
cd ~
git clone https://github.com/Nyr/openvpn-install.git
Cloning into 'openvpn-install'...
   remote: Counting objects: 345, done.
   remote: Total 345 (delta 0), reused 0 (delta 0), pack-reused 345
   Receiving objects: 100% (345/345), 99.15 KiB | 681.00 KiB/s, done.
   Resolving deltas: 100% (170/170), done.
```



## Run the installation script

Change to `./openvpn-install` directory and make sure the following files are present

```
cd ~/openvpn-install
ls -1
   LICENSE.txt
   README.md
   openvpn-install.sh
```

Make the script executable

```
chmod +x openvpn-install.sh
```

Run the OpenVPN installer

```
sudo ./openvpn-install.sh
```

You will get a couple of prompts to change or confirm default settings for the installation. After that, the following output should be displayed. - INPUT YOUR ENVIRONMENT VARIABLES -

```
Welcome to this OpenVPN "road warrior" installer!

   I need to ask you a few questions before starting the setup.
   You can leave the default options and just press enter if you are ok with them.

   First, provide the IPv4 address of the network interface you want OpenVPN
   listening to.
   IP address:

<YOUR-PUBLIC-IP-ADDRESS-OR-DDNS>

   Which protocol do you want for OpenVPN connections?
   1) UDP (recommended)
   2) TCP
   Protocol [1-2]:

<1>

   What port do you want OpenVPN listening to?
   Port: 

<1194>

   Which DNS do you want to use with the VPN?
   1) Current system resolvers
   2) 1.1.1.1
   3) Google
   4) OpenDNS
   5) Verisign
   DNS [1-5]:

<1>

   Finally, tell me your name for the client certificate.
   Please, use one word only, no special characters.
   Client name:

<server>

   Okay, that was all I needed. We are ready to set up your OpenVPN server now.
   Press any key to continue... *<Enter>*
```



If the installation was successful, you should get a success message at the end

```
 [ ... ]

 Finished!

 Your client configuration is available at: /root/server.ovpn
 If you want to add more clients, you simply need to run this script again!

 Main OpenVPN server configuration file is,/etc/openvpn/server.conf you
 are free to tune and tweak it to your liking.

```

Using the `cat` command, you can displayed the openvpn server configuration file.

```
cat /etc/openvpn/server.conf 
   port 1194
   proto udp
   dev tun
   sndbuf 0
   rcvbuf 0
   ca ca.crt
   cert server.crt
   key server.key
   dh dh.pem
   auth SHA512
   tls-auth ta.key 0
   topology subnet
   server 10.8.0.0 255.255.255.0
   ifconfig-pool-persist ipp.txt
   push "redirect-gateway def1 bypass-dhcp"
   push "dhcp-option DNS 8.8.8.8"
   push "dhcp-option DNS 8.8.4.4"
   keepalive 10 120
   cipher AES-256-CBC
   comp-lzo
   user nobody
   group nogroup
   persist-key
   persist-tun
   status openvpn-status.log
   verb 3
   crl-verify crl.pem
```

A new virtual network interface will be created during the setup process. This is used by OpenVPN clients as they connect to this virtual subnet. Confirm its presence using the `ip` command.

```
ip ad | grep tun0
4: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 100
   inet 10.8.0.1/24 brd 10.8.0.255 scope global tun0
```

The output should look like the above.

The default subnet for this interface is `10.8.0.0/24`.
OpenVPN server will be assigned `10.8.0.1` as his IP address, being the default gateway for the clients.

```
ip route | grep tun0
   10.8.0.0/24 dev tun0 proto kernel scope link src 10.8.0.1
```

To test this, we can do the following

```
sudo apt install traceroute
```

````
traceroute 10.8.0.1
   traceroute to 10.8.0.1 (10.8.0.1), 30 hops max, 60 byte packets
   1 node-01.computingforgeeks.com (10.8.0.1)  0.050 ms  0.018 ms  0.019 ms
````



## Generate OpenVPN client profile - .ovpn

After completing step 1 through 3, your VPN Server is ready for use. We need to generate VPN Profiles to be used by our users. The same script we used for the installation will be used for this. It manages the creation and revocation of user profiles.

```
cd ~
sudo ./openvpn-install.sh 
```

You should be prompt with the following. You simply have to select `Add a new user` .

```
Looks like OpenVPN is already installed.

   What do you want to do?
   1) Add a new user
   2) Revoke an existing user
   3) Remove OpenVPN
   4) Exit
   Select an option [1-4]:
<1>

   Tell me a name for the client certificate.
   Please, use one word only, no special characters.
   Client name:
<client1>

   Generating a 2048 bit RSA private key ...
   [ ... ]
   ... Data Base Updated
   
   Client client1 added, configuration is available at: /root/client1
```

From the output you can confirm the location of our new client profile under `/root/client1.ovpn` .
You need to copy this profile to the user openvpn application. The location of the associated private key is also provided but should not be used.

For informations about different openVPN client application, look at the following [official openvpn download site](https://openvpn.net/vpn-client/)
It supports multiplatform !

And that’it !