# Table des Matières

1. [Partie 1: Ansible par la Pratique – Installation](#partie-1-ansible-par-la-pratique--installation)
    - [Exo 1 : Ansible par la pratique](#exo-1--ansible-par-la-pratique)
    - [Exo 2 : Installation d'Ansible via un PPA](#exo-2--installation-dansible-via-un-ppa)
    - [Exo 3 : Installation d'Ansible via un Environnement Virtuel Python](#exo-3--installation-dansible-via-un-environnement-virtuel-python)
2. [Partie 2: Ansible par la pratique – Authentification](#partie-2--ansible-par-la-pratique--authentification)
3. [Partie 3: Ansible par la pratique – Configuration de base](##partie-3--ansible-par-la-pratique--configuration-de-base)
4. [Partie 4: Ansible par la pratique – Idempotence](##partie-4--ansible-par-la-pratique--Idempotence)
5. [Partie 5: Ansible par la pratique – Playbooks](##partie-5--ansible-par-la-pratique--Playbooks)
6. [Partie 6: Ansible par la pratique – Handler](##partie-6--ansible-par-la-pratique--Handler)
7. [Partie 7: Ansible par la pratique – Variables](##partie-7--ansible-par-la-pratique--Variables)
8. [Partie 8: Ansible par la pratique – Variables enregistrées](##partie-8--ansible-par-la-pratique--Variables-enregistrees)
9. [Partie 9: Ansible par la pratique – Facts et variables implicites](##partie-9--ansible-par-la-pratique--Facts-et-variables-implicites)
10. [Partie 10: Ansible par la pratique – Cibles heterogenes](##partie-10--ansible-par-la-pratique--Cibles-heterogenes)
---
# Partie 1: Ansible par la Pratique – Installation

## Exo 1 : Ansible par la pratique

1. **Démarrez la VM Ubuntu depuis le répertoire `atelier-01`** :
   ```sh
   [ema@localhost\:atelier-01] $ vagrant up
   ```

2. **Connectez-vous à cette VM** :
   ```sh
   [ema@localhost:atelier-01] $ vagrant ssh ubuntu
   ```
3. **Rafraîchissez les informations sur les paquets** :
   ```sh
   vagrant@ubuntu:~$ sudo apt update
   ```

4. **Recherchez le paquet ansible avec les options qui vont bien** :
      ```sh
   vagrant@ubuntu:~$ apt search ansible | grep ansible
   ```
5. **Installez le paquet officiel fourni par la distribution** :
   ```sh
   vagrant@ubuntu:~$ sudo apt install ansible -y
   ```

6. **Notez la version d’Ansible** :
   ```sh
   vagrant@ubuntu:~$ ansible --version
   ansible 2.10.8
   ```
7. **Déconnectez-vous et supprimez la VM.** :
   ```sh
   vagrant@ubuntu:~$ exit
   logout
   Connection to 127.0.0.1 closed.
   ema@localhost:atelier-01] $ vagrant destroy ubuntu -y
   ```

## Exo 2 : Installation d'Ansible via un PPA

1. **Ajout du dépot PPA** :
   ```sh
   vagrant@ubuntu:~$ sudo apt-add-repository ppa:ansible/ansible
   ```
2. **Installation de Ansible** :
   ```sh
   vagrant@ubuntu:~$ sudo apt install ansible -y
   ```
3. **Notez la version d’Ansible** :
   ```sh
   vagrant@ubuntu:~$ ansible --version
   ansible [core 2.17.8]
   ```
  
## Exo 3 : Installation d'Ansible via un Environnement Virtuel Python

 1. **Connexion à la VM Rocky** :
   ```sh
   [ema@localhost:atelier-01] $ vagrant ssh rocky
   ```
2. **Installation  de Python et pip** :
   ```sh
   [vagrant@rocky ~]$ sudo dnf install -y python3 python3-pip
   ```
3. **Création d'un venv** :
   ```sh
   [vagrant@rocky ~]$ python3 -m venv ~/.venv/ansible
   ```
4. **Activation du venv** :
   ```sh
   [vagrant@rocky ~]$ source ~/.venv/ansible/bin/activate
   (ansible) [vagrant@rocky ~]$
5. **Màj de pip** :
   ```sh
   (ansible) [vagrant@rocky ~]$ pip install --upgrade pip
   ```
6. **Installation de Ansible** :
   ```sh
   (ansible) [vagrant@rocky ~]$ pip install ansible
   ```

7. **Notez la version d’Ansible** :
   ```sh
   (ansible) [vagrant@rocky ~]$ ansible --version
   ansible [core 2.15.13]
   ```
---
# Partie 2 : Ansible par la pratique – Authentification

1. **Modification du fichier /etc/hosts** :
   ```sh
   127.0.0.1      localhost.localdomain  localhost
   192.168.56.10  control.sandbox.lan    control
   192.168.56.20  target01.sandbox.lan   target01
   192.168.56.30  target02.sandbox.lan   target02
   192.168.56.40  target03.sandbox.lan   target03
   ```
2. **Test de connexion aux VMs** :
   ```sh
   vagrant@control:~$ for HOST in target01 target02 target03; do ping -c 1 -q $HOST; done
   PING target01.sandbox.lan (192.168.56.20) 56(84) bytes of data.

   --- target01.sandbox.lan ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 2.270/2.270/2.270/0.000 ms
   PING target02.sandbox.lan (192.168.56.30) 56(84) bytes of data.

   --- target02.sandbox.lan ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 1.495/1.495/1.495/0.000 ms
   PING target03.sandbox.lan (192.168.56.40) 56(84) bytes of data.

   --- target03.sandbox.lan ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 2.072/2.072/2.072/0.000 ms
   ```

3. **Ajouter les targets aux hosts connus** :
   ```sh
   vagrant@control:~$ ssh-keyscan -t rsa target01 target02 target03 >> .ssh/known_hosts
   # target03:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.10
   # target02:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.10
   # target01:22 SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.10
   ```
4. **Génération des clés et ajout de la clé publique sur les VMs** :
   ```sh
   vagrant@control:~$ ssh-keygen
   vagrant@control:~$ ssh-copy-id target01
   vagrant@control:~$ ssh-copy-id target02
   vagrant@control:~$ ssh-copy-id target03
   ```
5. **¨Ping avec Ansible pour valider** :
   ```sh
   vagrant@control:~$ ansible all -i target01,target02,target03 -m ping
   target01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
   }
   target03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
   }
   target02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
   }
   ```
---
# Partie 3 : Ansible par la Pratique – Configuration de base

1. **Éditez /etc/hosts de manière à ce que les Target Hosts soient joignables par leur nom d’hôte simple** :
   ```sh
   192.168.56.20  target01.sandbox.lan   target01
   192.168.56.30  target02.sandbox.lan   target02
   192.168.56.40  target03.sandbox.lan   target03
   ```
2. **Configurez l’authentification par clé SSH avec les trois Target Hosts** :

   Tout d'abord je génère une clé sur le controleur :
   ```sh
   vagrant@control:~$ ssh-keygen
   ```
   Ensuite je copie ma clé publique sur l'ensemble de mes targets :
   ```sh
   vagrant@control:~$ for target in target01 target02 target03; do ssh-copy-id vagrant@$target; done
   ```
3. **Installez Ansible** :   
   ```sh
   vagrant@control:~$ sudo apt install ansible -y
   ```

4. **Envoyez un premier ping Ansible sans configuration** :   
   ```sh
   vagrant@control:~$ ansible all -i target01,target02,target03 -m ping
   target03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
    }
    target02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
    }
    target01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
    }
   ```
5. **Création du fichier de configuration Ansible et vérification de sa prise en compte par Ansible** :   
   ```sh
   vagrant@control:~/monprojet$ cat ansible.cfg 
   [defaults]
   inventory = ./hosts
   log_path = ~/journal/ansible.log
   vagrant@control:~/monprojet$ ansible --version
   ansible 2.10.8
   ```

6. **Spécifiez un inventaire nommé hosts** : 
   ```sh
      vagrant@control:~/monprojet$ cat hosts 
   [testlab]
   target01
   target02
   target03
   ```
7. **Activez la journalisation dans ~/journal/ansible.log** : 
   ```sh
      vagrant@control:~/monprojet$ cat hosts 
   [testlab]
   target01
   target02
   target03
   ```
8. **Testez la journalisation** :
```sh
vagrant@control:~/monprojet$ ansible all -i target01,target02,target03 -m ping
target02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
target01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
target03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
vagrant@control:~/monprojet$ cat ~/journal/ansible.log 
2025-02-12 10:59:33,094 p=3569 u=vagrant n=ansible | target02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
2025-02-12 10:59:33,096 p=3569 u=vagrant n=ansible | target01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
2025-02-12 10:59:33,308 p=3569 u=vagrant n=ansible | target03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

9. **Définissez explicitement l’utilisateur vagrant pour la connexion à vos cibles** :   
   ```sh
   vagrant@control:~/monprojet$ cat hosts
   [testlab]
   target01
   target02
   target03

   [testlab:vars]
   ansible_user=vagrant
   ```

10. **Envoyez un ping Ansible vers le groupe de machines [all]** : 
   ```sh
vagrant@control:~/monprojet$ ansible all -m ping
target02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
target01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
target03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
   ```
11. **Spécifiez un inventaire nommé hosts** : 
   ```sh
      vagrant@control:~/monprojet$ cat hosts 
   [testlab]
   target01
   target02
   target03
   ```

12. **Définissez l’élévation des droits pour l’utilisateur vagrant sur les Target Hosts** : 
   ```sh
   [testlab:vars]
   ansible_user=vagrant
   ansible_become=True
   ```
13. **Affichez la première ligne du fichier /etc/shadow sur tous les Target Hosts** : 
   ```sh
vagrant@control:~/monprojet$ ansible all -a "head -n 3 /etc/shadow"
target01 | CHANGED | rc=0 >>
root:*:19769:0:99999:7:::
daemon:*:19769:0:99999:7:::
bin:*:19769:0:99999:7:::
target02 | CHANGED | rc=0 >>
root:*:19769:0:99999:7:::
daemon:*:19769:0:99999:7:::
bin:*:19769:0:99999:7:::
target03 | CHANGED | rc=0 >>
root:*:19769:0:99999:7:::
daemon:*:19769:0:99999:7:::
bin:*:19769:0:99999:7:::
```

---
# Partie 4: Ansible par la pratique – Idempotence

1. **Installez successivement les paquets tree, git et nmap sur toutes les cibles** : 
   ```sh
   [vagrant@ansible ema]$ ansible testing -m package -a "name=tree,git,nmap state=present"
   ```

2. **Désinstallez successivement ces trois paquets en utilisant le paramètre supplémentaire state=absent** : 
   ```sh
   vagrant@ansible ema]$ ansible testing -m package -a "name=tree,git,nmap state=absent
   ```
3. **Copier le fichier /etc/fstab du Control Host vers tous les Target Hosts sous forme d’un fichier /tmp/test3.txt** : 
   ```sh
   [vagrant@ansible ema]$ ansible testing -m copy -a "src=/etc/fstab dest=/tmp/test3.txt"
    debian | CHANGED => {
    "changed": true,
    "checksum": "d39263691e31170df199aae3d93f7c556fbb3446",
    "dest": "/tmp/test3.txt",
    "gid": 0,
    "group": "root",
    "md5sum": "b6f1fe0d790a8d2f9b74b95df1c889dc",
    "mode": "0644",
    "owner": "root",
    "size": 743,
    "src": "/home/vagrant/.ansible/tmp/ansible-tmp-1739791110.345512-5984-279945349445399/source",
    "state": "file",
    "uid": 0
    }
    rocky | CHANGED => {
    "changed": true,
    "checksum": "d39263691e31170df199aae3d93f7c556fbb3446",
    "dest": "/tmp/test3.txt",
    "gid": 0,
    "group": "root",
    "md5sum": "b6f1fe0d790a8d2f9b74b95df1c889dc",
    "mode": "0644",
    "owner": "root",
    "secontext": "unconfined_u:object_r:user_home_t:s0",
    "size": 743,
    "src": "/home/vagrant/.ansible/tmp/ansible-tmp-1739791110.5364096-5983-105983908901582/source",
    "state": "file",
    "uid": 0
    }
    suse | CHANGED => {
    "changed": true,
    "checksum": "d39263691e31170df199aae3d93f7c556fbb3446",
    "dest": "/tmp/test3.txt",
    "gid": 0,
    "group": "root",
    "md5sum": "b6f1fe0d790a8d2f9b74b95df1c889dc",
    "mode": "0644",
    "owner": "root",
    "size": 743,
    "src": "/home/vagrant/.ansible/tmp/ansible-tmp-1739791110.2862656-5985-61319897632026/source",
    "state": "file",
    "uid": 0
   }
   ```

4. **Enfin, affichez l’espace utilisé par la partition principale sur tous les Target Hosts. Que remarquez-vous ?** : 
   ```sh
   [vagrant@ansible ema]$ ansible testing -m shell -a "df -h /"
   debian | CHANGED | rc=0 >>
   Filesystem      Size  Used Avail Use% Mounted on
   /dev/sda3       124G  2.3G  115G   2% /
   rocky | CHANGED | rc=0 >>
   Filesystem                  Size  Used Avail Use% Mounted on
   /dev/mapper/rl_rocky9-root   70G  2.4G   68G   4% /
   suse | CHANGED | rc=0 >>
   Filesystem      Size  Used Avail Use% Mounted on
   /dev/sda3       124G  2.8G  118G   3% /
   ```

---
# Partie 5: Ansible par la pratique – Playbooks

1. **Connexion au Control Host** : 
   ```sh
   [ema@localhost:atelier-10] $ vagrant ssh ansible
   ```

2. **Changement de répertoire pour etre dans le projet** : 
   ```sh
   vagrant@ansible ~]$ cd ansible/projets/ema/
   direnv: loading ~/ansible/projets/ema/.envrc
   direnv: export +ANSIBLE_CONFIG
   ```

Écrivez trois playbooks :

Un premier playbook apache-debian.yml qui installe Apache sur l’hôte debian avec une page personnalisée Apache web server running on Debian Linux.

3. **Playbook apache-debian :**
   ```sh
   [vagrant@ansible ema]$ cat apache-debian.yml 
   ---  # apache-01.yml

   - hosts: debian

   tasks:

   - name: Update package information
      apt:
        update_cache: true
        cache_valid_time: 3600

    - name: Install Apache
      apt:
        name: apache2

    - name: Start & enable Apache
      service:
        name: apache2
        state: started
        enabled: true

    - name: Install custom web page
      copy:
        dest: /var/www/html/index.html
        mode: 0644
        content: |
          <!doctype html>
          <html>
            <head>
              <meta charset="utf-8">
              <title>Test</title>
            </head>
            <body>
              <h1>My first Ansible-managed website</h1>
            </body>
          </html>
   ```
Vérification que c'est bien up :
   ```sh
   [vagrant@ansible ema]$ curl debian
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Test</title>
  </head>
  <body>
    <h1>My first Ansible-managed website</h1>
  </body>
</html>
   ```

4. **Playbook apache-rocky :** : 
   ```sh
   [[vagrant@ansible ema]$ cat apache-rocky.yml 
   ---
   - hosts: rocky
   tasks:
    - name: install httpd (apache2)
      dnf:
        name: httpd
        state: latest

    - name: start and enable httpd service
      service:
        name: httpd
        state: started
        enabled: true

    - name: edit de la page web
      copy:
        dest: /var/www/html/index.html
        mode: 0644
        content : |
         <!doctype html>
         <html>
           <head>
             <meta charset="utf-8">
             <title>Test</title>
           </head>
           <body>
               <h1>Apache web server running on Rocky Linux</h1>
           </body>
         </html>
   ```
Vérification que c'est bien up :
   ```sh
   [vagrant@ansible ema]$ curl rocky
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Test</title>
  </head>
  <body>
      <h1>Apache web server running on Rocky Linux</h1>
  </body>
</html>
   ```
5. **Playbook apache-suse :** : 
   ```sh
   [[vagrant@ansible ema]$ cat apache-suse.yml 
   ---
   - hosts: suse
   tasks:
    - name: install httpd (apache2)
      dnf:
        name: httpd
        state: latest

    - name: start and enable httpd service
      service:
        name: httpd
        state: started
        enabled: true

    - name: edit de la page web
      copy:
        dest: /var/www/html/index.html
        mode: 0644
        content : |
         <!doctype html>
         <html>
           <head>
             <meta charset="utf-8">
             <title>Test</title>
           </head>
           <body>
               <h1>Apache web server running on SUSE Linux</h1>
           </body>
         </html>
   ```
Vérification que c'est bien up :
   ```sh
[vagrant@ansible playbooks]$ curl suse
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Test</title>
  </head>
  <body>
      <h1>Apache web server running on SUSE Linux</h1>
  </body>
</html>
   ```
---
# Partie 6: Ansible par la pratique – Handler

1. **Écrivez un playbook chrony.yml qui assure la synchronisation NTP de tous vos Target Hosts** : 
```sh
[vagrant@control playbooks]$ cat chrony.yml 
---
- name: Configure NTP with chrony
  hosts: redhat
  become: yes

  tasks:
    - name: Install chrony package
      yum:
        name: chrony
        state: present

    - name: Enable and start chronyd service
      service:
        name: chronyd
        enabled: yes
        state: started

    - name: Install custom chrony configuration
      copy:
        dest: /etc/chrony.conf
        content: |
          server 0.fr.pool.ntp.org iburst
          server 1.fr.pool.ntp.org iburst
          server 2.fr.pool.ntp.org iburst
          server 3.fr.pool.ntp.org iburst
          driftfile /var/lib/chrony/drift
          makestep 1.0 3
          rtcsync
          logdir /var/log/chrony
      notify: Restart chronyd

  handlers:
    - name: Restart chronyd
      service:
        name: chronyd
        state: restarted
```

2. **Vérifiez la syntaxe correcte de votre playbook chrony.yml**
```sh
[vagrant@control playbooks]$ yamllint chrony.yml
```

3. **Vérifiez l’idempotence de votre playbook**
```sh
[vagrant@control playbooks]$ ansible-playbook chrony.yml 

PLAY [Configure NTP with chrony] ***********************************************************************************

TASK [Gathering Facts] *********************************************************************************************
ok: [target03]
ok: [target01]
ok: [target02]

TASK [Install chrony package] **************************************************************************************
ok: [target01]
ok: [target03]
ok: [target02]

TASK [Enable and start chronyd service] ****************************************************************************
ok: [target03]
ok: [target01]
ok: [target02]

TASK [Install custom chrony configuration] *************************************************************************
ok: [target02]
ok: [target01]
ok: [target03]

PLAY RECAP *********************************************************************************************************
target01                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
target02                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
target03                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```
---
# Partie 7: Ansible par la pratique – Variables

1. **Écrivez un playbook myvars1.yml qui affiche respectivement votre voiture et votre moto préférée en utilisant le module debug et deux variables mycar et mybike définies en tant que play vars** : 
   ```sh
   [vagrant@ansible playbooks]$ cat myvars1.yml
   ---
   - name: Afficher voiture et moto préférées
   hosts: localhost
   vars:
    mycar: "Tesla Model S"
    mybike: "Ducati Panigale"
   tasks:
    - name: Afficher la voiture préférée
      debug:
        msg: "Ma voiture préférée est {{ mycar }}."

    - name: Afficher la moto préférée
      debug:
        msg: "Ma moto préférée est {{ mybike }}."

   ```
Voici le résultat que j'obtiens :
```sh
[vagrant@ansible playbooks]$ ansible-playbook myvars1.yml 

PLAY [Afficher voiture et moto préférées] **************************************************************************

TASK [Gathering Facts] *********************************************************************************************
ok: [localhost]

TASK [Afficher la voiture préférée] ********************************************************************************
ok: [localhost] => {
    "msg": "Ma voiture préférée est Tesla Model S."
}

TASK [Afficher la moto préférée] ***********************************************************************************
ok: [localhost] => {
    "msg": "Ma moto préférée est Ducati Panigale."
}

PLAY RECAP *********************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

2. **En utilisant les extra vars, remplacez successivement l’une et l’autre marque – puis les deux à la fois – avant d’exécuter le play** : 
```sh
[vagrant@ansible playbooks]$ ansible-playbook myvars1.yml --extra-vars "mycar=Ferrari mybike=Harley-Davidson"

PLAY [Afficher voiture et moto préférées] **************************************************************************

TASK [Gathering Facts] *********************************************************************************************
ok: [localhost]

TASK [Afficher la voiture préférée] ********************************************************************************
ok: [localhost] => {
    "msg": "Ma voiture préférée est Ferrari."
}

TASK [Afficher la moto préférée] ***********************************************************************************
ok: [localhost] => {
    "msg": "Ma moto préférée est Harley-Davidson."
}

PLAY RECAP *********************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

3. **Écrivez un playbook myvars2.yml qui fait essentiellement la même chose que myvars1.yml, mais en utilisant une tâche avec set_fact pour définir les deux variables** : 
```sh
[vagrant@ansible playbooks]$ cat myvars2.yml 
---
- name: Afficher voiture et moto préférées avec set_fact
  hosts: localhost
  tasks:
    - name: Définir les variables mycar et mybike
      set_fact:
        mycar: "Tesla Model S"
        mybike: "Ducati Panigale"

    - name: Afficher la voiture préférée
      debug:
        msg: "Ma voiture préférée est {{ mycar }}."

    - name: Afficher la moto préférée
      debug:
        msg: "Ma moto préférée est {{ mybike }}."
```
Le résulat :
```sh
[vagrant@ansible playbooks]$ cat myvars2.yml 
---
- name: Afficher voiture et moto préférées avec set_fact
  hosts: localhost
  tasks:
    - name: Définir les variables mycar et mybike
      set_fact:
        mycar: "Tesla Model S"
        mybike: "Ducati Panigale"

    - name: Afficher la voiture préférée
      debug:
        msg: "Ma voiture préférée est {{ mycar }}."

    - name: Afficher la moto préférée
      debug:
        msg: "Ma moto préférée est {{ mybike }}."
```

4. **Là aussi, essayez de remplacer les deux variables en utilisant des extra vars avant l’exécution du play**

```sh
[vagrant@ansible playbooks]$ ansible-playbook myvars2.yml --extra-vars "mycar=Ferrari mybike=Harley-Davidson"

PLAY [Afficher voiture et moto préférées avec set_fact] ************************************************************

TASK [Gathering Facts] *********************************************************************************************
ok: [localhost]

TASK [Définir les variables mycar et mybike] ***********************************************************************
ok: [localhost]

TASK [Afficher la voiture préférée] ********************************************************************************
ok: [localhost] => {
    "msg": "Ma voiture préférée est Ferrari."
}

TASK [Afficher la moto préférée] ***********************************************************************************
ok: [localhost] => {
    "msg": "Ma moto préférée est Harley-Davidson."
}

PLAY RECAP *********************************************************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

5. **Écrivez un playbook myvars3.yml qui affiche le contenu des deux variables mycar et mybike mais sans les définir. Avant d’exécuter le playbook, définissez VW et BMW comme valeurs par défaut pour mycar et mybike pour tous les hôtes, en utilisant l’endroit approprié**

Tout d'abord je crée le fichier group_vars/all.yml :

```sh
[vagrant@ansible group_vars]$ cat all.yml 
---
mycar: VW
mybike: BMW
```

Mon playbook myvars3.yml :
```sh
[vagrant@ansible playbooks]$ cat myvars3.yml 
---
- name: Afficher voiture et moto préférées sans les définir
  hosts: localhost
  tasks:
    - name: Afficher la voiture préférée
      debug:
        msg: "Ma voiture préférée est {{ mycar }}."

    - name: Afficher la moto préférée
      debug:
        msg: "Ma moto préférée est {{ mybike }}."
```

Voici le résultat:
```sh
[vagrant@ansible playbooks]$ ansible-playbook myvars3.yml 

PLAY [Afficher voiture et moto préférées sans les définir] *********************************************************

TASK [Gathering Facts] *********************************************************************************************
ok: [localhost]

TASK [Afficher la voiture préférée] ********************************************************************************
ok: [localhost] => {
    "msg": "Ma voiture préférée est VW."
}

TASK [Afficher la moto préférée] ***********************************************************************************
ok: [localhost] => {
    "msg": "Ma moto préférée est BMW."
}

PLAY RECAP *********************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

6. **Effectuez le nécessaire pour remplacer VW et BMW par Mercedes et Honda sur l’hôte target02**

Tout d'abord, je modifie mon fichier inventory:
```sh
[vagrant@ansible ema]$ cat inventory 
[all]
target01 ansible_host=192.168.56.20
target02 ansible_host=192.168.56.30 mycar=Mercedes mybike=Honda
target03 ansible_host=192.168.56.40

[control]
ansible ansible_host=192.168.56.10
```

Je relance mon fichier myvars3.yml :

```sh
[vagrant@ansible playbooks]$ ansible-playbook myvars3.yml

PLAY [all] *********************************************************************************************************

TASK [Display the value of mycar and mybike] ***********************************************************************
ok: [ansible] => {
    "msg": "My car is a VW\nMy bike is a BMW\n"
}
ok: [target01] => {
    "msg": "My car is a VW\nMy bike is a BMW\n"
}
ok: [target02] => {
    "msg": "My car is a Mercedes\nMy bike is a Honda\n"
}
ok: [target03] => {
    "msg": "My car is a VW\nMy bike is a BMW\n"
}
```

7. **Écrivez un playbook display_user.yml qui affiche un utilisateur et son mot de passe correspondant à l’aide des variables user et password. Ces deux variables devront être saisies de manière interactive pendant l’exécution du playbook. Les valeurs par défaut seront microlinux pour user et yatahongaga pour password. Le mot de passe ne devra pas s’afficher pendant la saisie**

```sh
[vagrant@ansible playbooks]$ cat display_user.yml 
---
- name: Afficher un utilisateur et son mot de passe
  hosts: localhost
  gather_facts: false

  vars_prompt:
    - name: user
      prompt: "Veuillez entrer le nom d'utilisateur"
      default: "microlinux"
      private: false

    - name: password
      prompt: "Veuillez entrer le mot de passe"
      default: "yatahongaga"
      private: true

  tasks:
    - name: Afficher le nom d'utilisateur et le mot de passe
      ansible.builtin.debug:
        msg:
          - "Nom d'utilisateur : {{ user }}"
          - "Mot de passe : {{ password }}"

```

Voici le résultat :

```sh
[vagrant@ansible playbooks]$ ansible-playbook display_user.yml 
Veuillez entrer le nom d'utilisateur [microlinux]: toto
Veuillez entrer le mot de passe [yatahongaga]: 

PLAY [Afficher un utilisateur et son mot de passe] *****************************************************************

TASK [Afficher le nom d'utilisateur et le mot de passe] ************************************************************
ok: [localhost] => {
    "msg": [
        "Nom d'utilisateur : toto",
        "Mot de passe : toto"
    ]
}

PLAY RECAP *********************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

---
# Partie 8: Ansible par la pratique – Variables enregistrées

1. **Écrivez un playbook kernel.yml qui affiche les infos détaillées du noyau sur tous vos Target Hosts. Utilisez la commande uname -a et le module debug avec le paramètre msg** : 

Tout d'abord, voici mon playbook :

```sh
   [vagrant@ansible playbooks]$ cat kernel.yml 
---
# kernel.yml
- hosts: all
  gather_facts: false

  tasks:
    - name: Get kernel information
      command: uname -a
      changed_when: false
      register: kernel_info

    - debug:
        msg: "{{ kernel_info.stdout }}"
```

Voici le résultat :
```sh
[vagrant@ansible playbooks]$ ansible-playbook kernel.yml 

PLAY [all] *********************************************************************************************************

TASK [Get kernel information] **************************************************************************************
ok: [rocky]
ok: [suse]
ok: [debian]

TASK [debug] *******************************************************************************************************
ok: [rocky] => {
    "msg": "Linux rocky 5.14.0-362.13.1.el9_3.x86_64 #1 SMP PREEMPT_DYNAMIC Wed Dec 13 14:07:45 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux"
}
ok: [debian] => {
    "msg": "Linux debian 6.1.0-17-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.69-1 (2023-12-30) x86_64 GNU/Linux"
}
ok: [suse] => {
    "msg": "Linux suse 5.14.21-150500.55.39-default #1 SMP PREEMPT_DYNAMIC Tue Dec 5 10:06:35 UTC 2023 (2e4092e) x86_64 x86_64 x86_64 GNU/Linux"
}

PLAY RECAP *********************************************************************************************************
debian                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
rocky                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
suse                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

2. **Essayez d’obtenir le même résultat en utilisant le paramètre var du module debug**

Je mets le paramètre var :

```sh
   [vagrant@ansible playbooks]$ cat kernel.yml 
---
# kernel.yml
- hosts: all
  gather_facts: false

  tasks:
    - name: Get kernel information
      command: uname -a
      changed_when: false
      register: kernel_info

    - debug:
        var: "{{ kernel_info.stdout }}"
```

Lorsque je lance mon playbook, le résultat est le même :
```sh
[vagrant@ansible playbooks]$ ansible-playbook kernel.yml 

PLAY [all] *********************************************************************************************************

TASK [Get kernel information] **************************************************************************************
ok: [debian]
ok: [suse]
ok: [rocky]

TASK [debug] *******************************************************************************************************
ok: [rocky] => {
    "Linux rocky 5.14.0-362.13.1.el9_3.x86_64 #1 SMP PREEMPT_DYNAMIC Wed Dec 13 14:07:45 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux": "{{Linux rocky 5.14.0-362.13.1.el9_3.x86_64 #1 SMP PREEMPT_DYNAMIC Wed Dec 13 14:07:45 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux}}"
}
ok: [suse] => {
    "Linux suse 5.14.21-150500.55.39-default #1 SMP PREEMPT_DYNAMIC Tue Dec 5 10:06:35 UTC 2023 (2e4092e) x86_64 x86_64 x86_64 GNU/Linux": "{{Linux suse 5.14.21-150500.55.39-default #1 SMP PREEMPT_DYNAMIC Tue Dec 5 10:06:35 UTC 2023 (2e4092e) x86_64 x86_64 x86_64 GNU/Linux}}"
}
ok: [debian] => {
    "Linux debian 6.1.0-17-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.69-1 (2023-12-30) x86_64 GNU/Linux": "{{Linux debian 6.1.0-17-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.69-1 (2023-12-30) x86_64 GNU/Linux}}"
}

PLAY RECAP *********************************************************************************************************
debian                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
rocky                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
suse                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

3. **Écrivez un playbook packages.yml qui affiche le nombre total de paquets RPM installés sur les hôtes rocky et suse (rpm -qa | wc -l)**

```sh
[vagrant@ansible playbooks]$ cat packages.yml 
# packages.yml
- hosts: all
  gather_facts: true
  tasks:
    - name: Listing installed packages
      ansible.builtin.shell: rpm -qa | wc -l
      register: installed_packages
      changed_when: false
      when: ansible_os_family == "RedHat" or ansible_os_family == "Suse"
    - name: Display installed packages
      ansible.builtin.debug:
        var: installed_packages.stdout
      when: ansible_os_family == "RedHat" or ansible_os_family == "Suse"
```

Voici le résultat :

```sh
vagrant@ansible playbooks]$ ansible-playbook packages.yml 

PLAY [all] *********************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************
ok: [rocky]
ok: [debian]
ok: [suse]

TASK [Listing installed packages] **********************************************************************************
skipping: [debian]
ok: [rocky]
ok: [suse]

TASK [Display installed packages] **********************************************************************************
ok: [rocky] => {
    "installed_packages.stdout": "671"
}
skipping: [debian]
ok: [suse] => {
    "installed_packages.stdout": "917"
}

PLAY RECAP *********************************************************************************************************
debian                     : ok=1    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0   
rocky                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
suse                       : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

---
# Partie 9: Ansible par la pratique – Facts et variables implicites

Écrivez trois playbooks pour afficher des informations sur chacun des Target Hosts :

1. **Ecrire pkg-info.yml pour afficher le gestionnaire de paquets utilisé**
```sh
[vagrant@ansible playbooks]$ cat pkg-info.yml 
---
- name: Display package manager information
  hosts: all

  tasks:
    - name: Show package manager
      debug:
        msg: "The package manager on {{ inventory_hostname }} is {{ ansible_pkg_mgr }}"

```

Le résultat est :
```sh
[vagrant@ansible playbooks]$ ansible-playbook pkg-info.yml 

PLAY [Display package manager information] *************************************************************************

TASK [Gathering Facts] *********************************************************************************************
ok: [rocky]
ok: [debian]
ok: [suse]

TASK [Show package manager] ****************************************************************************************
ok: [rocky] => {
    "msg": "The package manager on rocky is dnf"
}
ok: [debian] => {
    "msg": "The package manager on debian is apt"
}
ok: [suse] => {
    "msg": "The package manager on suse is zypper"
}

PLAY RECAP *********************************************************************************************************
debian                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
rocky                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
suse                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

2. **Ecrire python-info.yml pour afficher la version de Python installée**
```sh
---
- name: Display Python version information
  hosts: all

  tasks:
    - name: Show Python version
      debug:
        msg: "The Python version on {{ inventory_hostname }} is {{ ansible_python_version }}"
```

Le résultat est :
```sh
[vagrant@ansible playbooks]$ ansible-playbook python-info.yml 

PLAY [Display Python version information] **************************************************************************

TASK [Gathering Facts] *********************************************************************************************
ok: [debian]
ok: [rocky]
ok: [suse]

TASK [Show Python version] *****************************************************************************************
ok: [rocky] => {
    "msg": "The Python version on rocky is 3.9.18"
}
ok: [debian] => {
    "msg": "The Python version on debian is 3.11.2"
}
ok: [suse] => {
    "msg": "The Python version on suse is 3.6.15"
}

PLAY RECAP *********************************************************************************************************
debian                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
rocky                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
suse                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

3. **Ecrire dns-info.yml pour afficher le(s) serveur(s) DNS utilisé(s)**
```sh
[vagrant@ansible playbooks]$ cat dns-info.yml 
---
- name: Display DNS server information
  hosts: all

  tasks:
    - name: Show DNS servers
      debug:
        msg: "The DNS servers on {{ inventory_hostname }} are {{ ansible_dns.nameservers }}"
```

Le résultat est :

```sh
[vagrant@ansible playbooks]$ ansible-playbook dns-info.yml 

PLAY [Display DNS server information] ******************************************************************************

TASK [Gathering Facts] *********************************************************************************************
ok: [debian]
ok: [rocky]
ok: [suse]

TASK [Show DNS servers] ********************************************************************************************
ok: [rocky] => {
    "msg": "The DNS servers on rocky are ['10.0.2.3']"
}
ok: [debian] => {
    "msg": "The DNS servers on debian are ['4.2.2.1', '4.2.2.2', '208.67.220.220']"
}
ok: [suse] => {
    "msg": "The DNS servers on suse are ['10.0.2.3']"
}

PLAY RECAP *********************************************************************************************************
debian                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
rocky                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
suse                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  
```

---
# Partie 10: Ansible par la pratique – Cibles heterogenes


