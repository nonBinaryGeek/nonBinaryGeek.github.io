---
sort: 1
---

# OpenSSH under Windows10

The following is a brief tutorial on how to use the built-in OpenSSH client & server agent from Windows10 to connect to a remote Linux server. It should be noted that as a requirement for this to work, you should have previously installed the optional feature package named ‘openssh-client’ from Windows10. Also, the remote Linux server should be configure with SSH port open and ready for connection.



## Step 1 - Verification (if you already have a key generated, you can skip to Step 3)

Open windows command prompt and verify if you already have a public key. (change the path according to your drive and username)

	cd C:\Users\John\.ssh
	dir

Your output should look like this :

```
 Volume in drive C has no label.
 Volume Serial Number is ACAB-1213

 Directory of C:\Users\John\.ssh

2021-09-23  06:26 AM               522 authorized_keys
2021-09-19  06:07 PM               748 id_ecdsa
2021-09-19  06:07 PM               276 id_ecdsa.pub
2021-11-09  06:17 PM             1,625 known_hosts
               4 File(s)          3,171 bytes
               0 Dir(s)  140,615,950,336 bytes free

```

If you don't see your key and only a known_hosts file, you'll create a new one. If the \.ssh directory does not exist, create it with the following command, from your user directory :

```
mkdir .ssh
```



## Step 2 - Generate key pairs

From your user directory on Windows (C:\Users\John), generate the key pairs.

```
ssh-keygen -t ecdsa -b 521
```

When prompt to save the file, make sure to save it in your `\.ssh` directory.

After the key pairs is generated, it will asked you to enter a passphrase. Leaving it blank will furthermore never required password from this PC - User to access remote server through ssh. It is strongly recommended that you DO NOT leave it blank as anyone gaining access to your PC could connect to your server. Instead, the passphrase will be enabled and secretly stored with Windows ssh-agent. This way, we still gain the ability to remote access without entering password/passphrase while maintaining security by hiding the actual key.

To make sure the keys are there, go to your `\.ssh`  directory and issued the `dir` command

```
cd c:\Users\John\.ssh
dir
```

You should now see your private and public keys named respectively **id_ecdsa** and **id_ecdsa.pub**.



## Step 3 - Share your public key to remote server

First, make sure the .ssh directory exists in remote server. To verify, login to your remote server in command prompt and issued the list command from your home directory.

```
ssh <username>@<remote-ip-address>
```

Enter the requested password to login.

In your remote home directory, issued the following

```shell
ls -la
```

You should see the .ssh directory if it exists. If not, do the following 

```shell
mkdir .ssh
```

Without closing the terminal of your remote connection, open a new command prompt from Windows 10 user .ssh directory and use `scp` command.

> *Example :*
>
> ```
> scp "C:\Users\John\.ssh\id_ecdsa.pub" john@192.168.1.30:~/.ssh
> ```

The syntax as shown above depends on your setup. Replace inputs with correct information. The global syntax is the following :

```
scp "C:\Users\[username]\.ssh\id_ecdsa.pub" [username]@[hostname]:[destination_path]
```

Now go back to your terminal connected to the remote server.



## Step 4 - Prepare the remote server

From your remote server, under ~/.ssh directory, you should see the public key named id_ecdsa.pub.

```shell
ls -la
```

Now, we will append the key to another file under ~/.ssh called authorized_keys. Every time a new public key needs to be added, this is where we'll write it.

```shell
cat id_ecdsa.pub >> authorized_keys
```

Make sure it has the right permissions.

```shell
chmod 640 authorized_keys
```

When done, you should remove the actual key `id_ecdsa.pub` from the system.

```shell
rm id_ecdsa.pub
```

Logout from the server. On your next connection with ssh, it should ask for the passphrase you created before and automatically connect with ssh.



## Step 5 - Secure your key on Windows host with POWERSHELL

Remember that private key files are the equivalent of a password should be protected the same way you protect your password. To help with that, use ssh-agent to securely store the private keys within a Windows security context, associated with your Windows login. To do that, start the ssh-agent service as Administrator and use ssh-add to store the private key.

By default the ssh-agent service is disabled. Allow it to be manually started for the next step to work. Make sure you're running as an Administrator. Make sure you're using POWERSHELL.

```powershell
Get-Service ssh-agent | Set-Service -StartupType Manual
```

Start the service

```powershell
Start-Service ssh-agent
```

This should return a status of Running

```powershell
Get-Service ssh-agent
```

Now load your key files into ssh-agent

```powershell
ssh-add C:\Users\<USERNAME>\.ssh\id_ecdsa
```



## Step 6 - (Optional) Create a *.bat file to quickly connect to remote server

Create a *.bat file on your desktop. Give it a meaningful name for your need. Inside the file, using notepad, we we'll write the followings (don't forget to change the file with your actual information) :

```
@ECHO OFF
ssh.exe <REMOTE.USERNAME>@<REMOTE-IP-ADDRESS>
PAUSE
```

Save and quit. Now, executing the *.bat file or double clicking it should connect you automatically to the remote server.



### That's it ! You're done ! ###
