---
title: Installation
sort: 1
---



# Installation de l'environnement de travail

> Ce guide d'installation ce veut claire et concis. Il n'y est donc pas question du fonctionnement avancé et des raisons motivants l'utilisations d'une commande ou d'un programme face à un autre. Les références afin d'obtenir d'avantages d'informations sont présentées au bas de la page.



**PRÉREQUIS:**

- Vous avez un compte GitHub. Si ce n'est pas le cas, créez votre compte en suivant [ce lien](https://github.com/signup?ref_cta=Sign+up&ref_loc=header+logged+out&ref_page=%2F&source=header-home).

##  Windows Subsystem for Linux (Recommendée)

### Installation du logiciel WSL

Afin d'utiliser cette option sous Windows, il suffit de l'activer dans les *Windows Features*. Vous pouvez faire une recherche dans la barre de recherche windows en y inscrivant : « *Turn Windows Features on or off* ». Il est aussi possible de faire les installation nécessaire simplement à partir de PowerShell en tant qu'Administrateur.

```powershell
wsl --install
```

Redémarrer l'ordinateur. La distribution installé par défaut est Ubuntu. Advenant un problème de connection internet - résolution DNS, ajouter directement les serveurs DNS dans le fichier `/etc/resolv.conf` tel que `nameserver 8.8.8.8`. Se fichier à tendance mal se générer et donc à priver le système de sa connection internet.

Une fois l'ordinateur redémarré, il suffit de lancer Ubuntu et de suivre la courte installation. 

> Note: La distribution Ubuntu est disponible dans le Microsoft Store déjà présent sur l'ordinateur advenant une erreur lors de l'installation.

Si vous préférez une autre distribution, vous pouvez utiliser la commande suivante dans PowerShell afin d'obtenir une liste des distributions disponibles.

```powershell
wsl --list --online
```



### Configuration de GitHub

Une fois que WSL est installé, on peut installer `git` sur notre système.

```shell
sudo apt update && sudo apt upgrade -y
sudo apt install git -y
```



Pour configurer votre espace de travail Git, ouvrez une ligne de commande pour la distribution  dans laquelle vous travaillez et définissez votre nom avec la commande suivante (en remplaçant "**your name**" par votre nom d'utilisateur et "**your email**" par l'adresse courriel associée à votre compte) : 

```sh
git config --global user.name "Your Name"
git config --global user.email "youremail@domain.com"
```



Parfois, il arrive que GitHub soit restrictif lorsque l'on tente de modifier une *repo* qui nous appartient. À ce moment, il nous est impossible d'utiliser notre email et notre mot de passe lors des modifications. Il est donc préférable de créer un *token* d'authentification que l'on aura qu'à copier coller lorsqu'un mot de passe sera exigé. Afin de créer un *token*, il faut se connecter à [GitHub](https://github.com/login), se diriger sous nos *paramètres de compte*, descendre au bas de la page et selectionner les *Paramètres de Developpeur*.

<img src="img/github.png" style="zoom:50%;" />



<img src="img/github2.png" style="zoom:63%;" />



<img src="img/github3.png" style="zoom:100%;" />



**(Optionnel)**

[Git Credential Manager (GCM)](https://github.com/GitCredentialManager/git-credential-manager) vous permet de vous authentifiez à un serveur Git distant. Ainsi, il est possible de mettre en place un méchanisme d'authentification permettant d'utiliser votre compte via la ligne de commande.

Pour configurer GCM en concordance avec une distribution WSL, ouvrez votre distribution (Ubuntu) et saisissez cette commande: 

```sh
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe"
```

Pour plus de détails relativement à l'[authentification sous GitHub](https://docs.github.com/en/authentication).



### Installation de Jekyll sur Ubuntu

**Installer les dépendances**

Installez Ruby et les autres [prérequis ](https://jekyllrb.com/docs/installation/#requirements): 

```sh
sudo apt-get install ruby-full build-essential zlib1g-dev
```

Évitez d'installer les futures packages RubyGems (appelés gems) en tant qu'utilisateur root. Préférablement, configurez un répertoire d'installation de gem pour votre compte utilisateur auxquels nous ajouterons les `path` nécessaires dans notre fichier `~/.bashrc`.

```sh
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Enfin, installez Jekyll et Bundler : 

```ruby
gem install jekyll bundler
```

Finalement, on peut créer notre nouveau siteweb à l'aide de la commande `jekyll new <siteweb.name>`

```ruby
jekyll new mon-siteweb
```

Le résultat devrait ressembler à ceci:

```sh
phil@debian-client:~$ jekyll new mon-sitweb
Running bundle install in /home/phil/mon-sitweb...
  Bundler: Fetching gem metadata from https://rubygems.org/..........
  Bundler: Resolving dependencies...
  Bundler: Using bundler 2.3.4
  Bundler: Using public_suffix 4.0.6
  Bundler: Using colorator 1.1.0
  Bundler: Using concurrent-ruby 1.1.9
  Bundler: Using eventmachine 1.2.7
  Bundler: Using http_parser.rb 0.8.0
  Bundler: Using ffi 1.15.5
  Bundler: Using forwardable-extended 2.6.0
  Bundler: Using rb-fsevent 0.11.0
  Bundler: Fetching rexml 3.2.5
  Bundler: Using liquid 4.0.3
  Bundler: Using mercenary 0.4.0
  Bundler: Using rouge 3.27.0
  Bundler: Using safe_yaml 1.0.5
  Bundler: Using unicode-display_width 1.8.0
  Bundler: Using addressable 2.8.0
  Bundler: Using em-websocket 0.5.3
  Bundler: Using i18n 1.8.11
  Bundler: Using sassc 2.4.0
  Bundler: Using rb-inotify 0.10.1
  Bundler: Using pathutil 0.16.2
  Bundler: Using terminal-table 2.0.0
  Bundler: Using jekyll-sass-converter 2.1.0
  Bundler: Using listen 3.7.0
  Bundler: Using jekyll-watch 2.2.1
  Bundler: Installing rexml 3.2.5
  Bundler: Using kramdown 2.3.1
  Bundler: Using kramdown-parser-gfm 1.1.0
  Bundler: Using jekyll 4.2.1
  Bundler: Fetching jekyll-feed 0.16.0
  Bundler: Fetching jekyll-seo-tag 2.7.1
  Bundler: Installing jekyll-feed 0.16.0
  Bundler: Installing jekyll-seo-tag 2.7.1
  Bundler: Fetching minima 2.5.1
  Bundler: Installing minima 2.5.1
  Bundler: Bundle complete! 6 Gemfile dependencies, 31 gems now installed.
  Bundler: Use `bundle info [gemname]` to see where a bundled gem is installed.
New jekyll site installed in /home/phil/mon-sitweb.
phil@debian-client:~$
```

On peu



### Clonage de la Repo

Afin d'obtenir une copie du Site, il suffit d'utiliser la commande git. Par contre, il est aussi préférable de se créer un répertoire qui servira d'espace de travail. Ici, nous avons créé un répertoire nommé **git**.

```sh
cd ~/
mkdir git
cd git
```

Enfin, on peut cloner la *repo* située sous [ce lien](https://github.com/nonBinaryGeek/jekyll-modele.git).

```sh
git clone https://github.com/nonBinaryGeek/jekyll-modele.git
  Cloning into 'jekyll-modele'...
  remote: Enumerating objects: 443, done.
  remote: Counting objects: 100% (443/443), done.
  remote: Compressing objects: 100% (311/311), done.
  remote: Total 443 (delta 130), reused 424 (delta 113), pack-reused 0
  Receiving objects: 100% (443/443), 3.11 MiB | 9.91 MiB/s, done.
  Resolving deltas: 100% (130/130), done.
```

Afin de prévisualiser notre site web, on se dirige dans le répertoire tout juste créer.

```sh
ls
jekyll-modele
cd jekyll-modele/
ls -lt
drwxr-xr-x 5 phil phil 4096 Jan  9 19:34 assets
-rw-r--r-- 1 phil phil  841 Jan  9 19:34 package.json
-rw-r--r-- 1 phil phil   25 Jan  9 19:34 requirements.txt
-rw-r--r-- 1 phil phil 2571 Jan  9 19:34 update.sh
-rw-r--r-- 1 phil phil  897 Jan  9 19:34 webpack.config.js
drwxr-xr-x 4 phil phil 4096 Jan  9 19:34 _sass
drwxr-xr-x 2 phil phil 4096 Jan  9 19:34 About
-rw-r--r-- 1 phil phil    0 Jan  9 19:34 CNAME
drwxr-xr-x 5 phil phil 4096 Jan  9 19:34 Documentations
-rw-r--r-- 1 phil phil   89 Jan  9 19:34 Gemfile
-rw-r--r-- 1 phil phil 8150 Jan  9 19:34 Gemfile.lock
-rw-r--r-- 1 phil phil 1091 Jan  9 19:34 LICENSE
-rw-r--r-- 1 phil phil 1414 Jan  9 19:34 Makefile
-rw-r--r-- 1 phil phil 2440 Jan  9 19:34 README.md
-rw-r--r-- 1 phil phil 1359 Jan  9 19:34 _config.yml
drwxr-xr-x 7 phil phil 4096 Jan  9 19:34 _includes
drwxr-xr-x 3 phil phil 4096 Jan  9 19:34 _layouts
```

On peut utiliser l'utilitaire `jekyll`, une fois dans le répertoire, afin de créer temporairement le siteweb qui sera accessible à l'adresse `http://127.0.0.1:4000`  

```sh
bundle exec jekyll serve

Configuration file: /home/phil/git/jekyll-modele/_config.yml
            Source: /home/phil/git/jekyll-modele
       Destination: /home/phil/git/jekyll-modele/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
      Remote Theme: Using theme nonbinarygeek/nonbinarygeek.github.io
   GitHub Metadata: No GitHub API authentication could be found. Some fields may be missing or have incorrect data.
                    done in 15.556 seconds.
/home/phil/gems/gems/pathutil-0.16.2/lib/pathutil.rb:502: warning: Using the last argument as keyword parameters is deprecated
                    Auto-regeneration may not work on some Windows versions.
                    Please see: https://github.com/Microsoft/BashOnWindows/issues/216
                    If it does not work, please upgrade Bash on Windows or run Jekyll with --no-watch.
 Auto-regeneration: enabled for '/home/phil/git/jekyll-modele'
    Server address: http://127.0.0.1:4000
  Server running... press ctrl-c to stop.
```

