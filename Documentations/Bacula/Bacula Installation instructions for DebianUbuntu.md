---
sort: 1
---

# Bacula Installation instructions for Debian/Ubuntu



## Install Bacula Server

In order to install Bacula Server, we issue the following set of commands

```
sudo apt update -y && sudo apt upgrade -Y
```

```
sudo apt install bacula -y
```

The installation process will prompt the user for the following:

- Mail Server config (Can be set to local and change later)
- Database configuration for bacula-directory-pgsql (select localhost)
- Database password for Bacula PostgreSQL



## Scenario and Configuration Files Structure

We need to configure our Bacula Server so it can backup the other servers inside our network. For this, we need to established our network addressing table.

- Subnet range : `10.32.0.224/28`
- Bacula Server IP Address : `10.32.0.230/28`
- Domain : `GECKO.LOCAL`
- Domain Controller : `Active Directory`

| Fully Qualified Domain name - FQDN | IP ADDRESS  |
| ---------------------------------- | ----------- |
| wins01.gecko.local                 | 10.32.0.227 |
| dns.gecko.local                    | 10.32.0.228 |
| ntpsys.gecko.local                 | 10.32.0.229 |
| bacula.gecko.local                 | 10.32.0.230 |
| web.gecko.local                    | 10.32.0.231 |
| wiki.gecko.local                   | 10.32.0.232 |
| client.gecko.local                 | 10.32.0.233 |



As for the backup server, we will configure it with a few things in mind.

- Our backup destination is under `/backup`
- We can either connect a drive and use it as our archive device by mounting it under our backup destination, or we can simply use this directory as the backup archive device. In both cases, the same configuration will be apply.
- We need to backup the configuration files before playing with them, as we will remove the parts that are useless for our situation.

**Configuration files structure**

```
admin@bacula:~$ tree /etc/bacula
.
├── bacula-dir.conf
├── bacula-fd.conf
├── bacula-sd.conf
├── bconsole.conf
├── common_default_passwords
└── scripts
    ├── baculabackupreport
    ├── btraceback.gdb
    ├── delete_catalog_backup
    ├── disk-changer
    ├── isworm
    ├── make_catalog_backup
    ├── make_catalog_backup.pl
    ├── mtx-changer
    ├── mtx-changer.conf
    ├── query.sql
    └── tapealert

1 directory, 16 files
```



## Configuration of the Bacula Server

Let's create the backup directory.

```
sudo mkdir /backup
```

Then, we give the `bacula` user/group ownership for the directory.

```
sudo chown -R bacula:bacula /backup
```

We will now backup our configuration files and create new ones without all those commented lines.

```
cd /etc/bacula
sudo mv bacula-fd.conf bacula-fd.conf.back | sudo touch bacula-fd.conf && sudo grep -v "^#" bacula-fd.conf.back | sudo tee bacula-fd.conf >/dev/null
sudo mv bacula-sd.conf bacula-sd.conf.back | sudo touch bacula-sd.conf && sudo grep -v "^#" bacula-sd.conf.back | sudo tee bacula-sd.conf >/dev/null
sudo mv bacula-dir.conf bacula-dir.conf.back | sudo touch bacula-dir.conf && sudo grep -v "^#" bacula-dir.conf.back | sudo tee bacula-dir.conf >/dev/null
```

Start by editing the `bacula-sd.conf` file. Locate the **Device** and **Autochanger** sections and comment them completely. We can add our own Device Definition. The final result - *omitting the commented Device and Autochanger sections* - should look like the configuration below, where :

- Our Device Definition is at the end of the file.
- Archive Device should be the previously created directory -e.g. `/backup` .
- Director `Password` identified here by `Name = debian-dir` is needed for next part, thus we copy it.
- The Storage Section is providing us with a name -e.g. `Name = debian-sd`. We need to know this name for next part.

 ```
 Storage {
   Name = debian-sd
   SDPort = 9103
   Working Directory = "/var/lib/bacula"
   Pid Directory = "/run/bacula"
   Plugin Directory = "/usr/lib/bacula"
   Maximum Concurrent Jobs = 20
   SDAddress = 127.0.0.1
 }
 
 Director {
   Name = debian-dir
   Password = "$DEBIAN-DIR-PASSWORD"
 }
 
 Director {
   Name = debian-mon
   Password = "$DEBIAN-MON-PASSWORD"
   Monitor = yes
 }
 Messages {
   Name = Standard
   director = debian-dir = all
 }
 
 Device {
   Name = BackupDevice
   Media Type = File
   Archive Device = /backup
   LabelMedia = yes;
   Random Access = Yes;
   AutomaticMount = yes;
   RemovableMedia = no;
   AlwaysOpen = no;
   Maximum Concurrent Jobs = 5
 }
 ```

After saving the file, we can start and enable *bacula-sd* service.

```
sudo systemctl enable bacula-sd.service
sudo systemctl restart bacula-sd.service
```

Finally, we need to configure the **Bacula Director** configuration file.

```

  [...]

# Basic Storage, FileSet, Schedule and Job definition
#
Storage {
  Name = debian-sd
  Address = 127.0.0.1
  Password = "$DEBIAN-DIR-PASSWORD"
  Device = BackupDevice
  Media Type = File
}

FileSet {
  Name = "Local-file"
    Include {
      Options {
        compression = GZIP
        signature = SHA1
      }
      File = /var/www/html
  }
}

Schedule {
  Name = "LocalDaily"
  Run = Full daily at 06:00
}

Job {
  Name = "LocalBackup"
  JobDefs = "DefaultJob"
  Enabled = yes
  Level = Full
  FileSet = "Local-file"
  Schedule = "LocalDaily"
  Storage = debian-sd
  Write Bootstrap = "/var/lib/bacula/LocalhostBackup.bsr"
}
```

