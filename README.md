# viper-docker

Viper docker provides a dockerized version of the viper framework.

## Installation and Setup

To download the docker container use the following commands.

```bash
git clone https://github.com/viper-framework/viper-docker.git
cd viper-docker
docker build -t viper .
```

## QuickStart

### Interactive Mode

When run using only `docker run viper` this docker container runs the Viper command and then exits immediately after it opens. This is not very useful.

To start viper and then stay in the viper interactive command line interface (CLI) you must add the `interactive` and `TTY` flags.

```bash
docker run -it viper
```

#### *Required* for your first time running Viper in a dockerfile

The latest release of viper (1.2) will not allow you to create an initial project from within the viper interface unless at least one other project has already been created. Viper uses [projects](https://viper-framework.readthedocs.io/en/latest/usage/concepts.html#projects) to allow you to organize and operate on a specific collection of files. The first time you run the Viper docker container you will want to add your initial project from the command line.

```bash
docker run -it viper ../viper/viper.py -p [YOUR PROJECT NAME HERE]
```

### Sharing a folder with the Viper docker container

If you want to share an existing folder of malware with the Viper docker container you can share it using the `--volume list` flag.

```bash
docker run -it -v ~/malware:/var/malware viper
```

This will set up a bindmount volume that links a /var/malware directory from inside the Nginx container to the ~/malware directory on my host machine. Docker uses a : to split the host's path from the container path, and the host path always comes first.


```bash
none:viper-docker $ docker run -it -v ~/malware:/var/malware viper ../viper/viper.py -p unknown
         _
        (_)
   _   _ _ ____  _____  ____
  | | | | |  _ \| ___ |/ ___)
   \ V /| | |_| | ____| |
    \_/ |_|  __/|_____)_| v1.2
          |_|

You have 0 files in your unknown repository
unknown viper > open -f /var/malware/Unknown
[*] Session opened on /var/malware/Unknown
unknown viper >
```


### Saving data and resuming work in your viper-docker container

When you use `docker run` to start a container, it creates a new container based on the image you have specified. **Activities and data will not persist** between one call of `docker run` and the next `docker run` call.


```bash
none:viper-docker $ # We have a file we want to look at in our host malware folder
none:viper-docker $ ls ~/malware
Unknown
none:viper-docker $ # Let's start docker to explore that file
none:viper-docker $ docker run -it -v ~/malware:/var/malware viper ../viper/viper.py -p unknown
         _
        (_)
   _   _ _ ____  _____  ____
  | | | | |  _ \| ___ |/ ___)
   \ V /| | |_| | ____| |
    \_/ |_|  __/|_____)_| v1.2
          |_|

You have 0 files in your unknown repository
unknown viper > open -f /var/malware/Unknown
[*] Session opened on /var/malware/Unknown
unknown viper Unknown > store
[*] Session opened on /home/viper/workdir/projects/unknown/binaries/a/6/3/5/a635f37c16fc05e554a6c7b3f696e47e8eaf3531407cac27e357851cb710e615
[+] Stored file "Unknown" to /home/viper/workdir/projects/unknown/binaries/a/6/3/5/a635f37c16fc05e554a6c7b3f696e47e8eaf3531407cac27e357851cb710e615
unknown viper Unknown > tags --add trojan
[*] Session opened on /home/viper/workdir/projects/unknown/binaries/a/6/3/5/a635f37c16fc05e554a6c7b3f696e47e8eaf3531407cac27e357851cb710e615
[*] Tags added to the currently opened file
[*] Refreshing session to update attributes...
unknown viper Unknown > exit
none:viper-docker $ # Woops! We accidentally exited the session
none:viper-docker $ # So, we re-run the previous docker run command
none:viper-docker $ docker run -it -v ~/temp/malware:/var/malware viper ../viper/viper.py -p unknown
         _
        (_)
   _   _ _ ____  _____  ____
  | | | | |  _ \| ___ |/ ___)
   \ V /| | |_| | ____| |
    \_/ |_|  __/|_____)_| v1.2
          |_|

You have 0 files in your unknown repository
unknown viper > sessions --list
[*] There are no opened sessions
unknown viper > find all
unknown viper >
```

By using the `docker run` command we created a new container.

#### Restarting an existing session

You **can** restart an existing container after it exited and your changes are still there.

To continue your work from a previous viper-docker container you have to first find the container id. The `docker ps -a` flag shows the id's of previously running containers.

```bash
none:viper-docker $ docker ps -a
CONTAINER ID        IMAGE               COMMAND                   CREATED             STATUS                           PORTS               NAMES
697ec82c6734        viper               "../viper/viper.py..."    8 minutes ago       Up 7 minutes                                         loving_swanson
```

Once you have found the container id you can restart the container and attach to it. *NOTE:* when you attach it will not print the command prompt. You can just press the ENTER key to show the command prompt.

```bash
none:viper-docker $ docker start 697ec82c6734
697ec82c6734
none:viper-docker $ docker attach 697ec82c6734

unknown viper > find all
+---+---------+-----------------------+----------------------------------+--------+
| # | Name    | Mime                  | MD5                              | Tags   |
+---+---------+-----------------------+----------------------------------+--------+
| 1 | Unknown | application/x-dosexec | 25d562f46c14c5267d56722f6a43b8ed | trojan |
+---+---------+-----------------------+----------------------------------+--------+
```
