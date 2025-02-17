# Table des Matières

1. [Partie 1: Ansible par la Pratique – Installation](#partie-1-ansible-par-la-pratique--installation)
    - [Exo 1 : Ansible par la pratique](#exo-1--ansible-par-la-pratique)
    - [Exo 2 : Installation d'Ansible via un PPA](#exo-2--installation-dansible-via-un-ppa)
    - [Exo 3 : Installation d'Ansible via un Environnement Virtuel Python](#exo-3--installation-dansible-via-un-environnement-virtuel-python)
2. [Partie 2: Ansible par la pratique – Authentification](#partie-2--ansible-par-la-pratique--authentification)
3. [Partie 3: Ansible par la pratique – Configuration de base](##partie-3--ansible-par-la-pratique--configuration-de-base)
4. [Partie 4: Ansible par la pratique – Idempotence](##partie-4--ansible-par-la-pratique--Idempotence)
5. [Partie 5: Ansible par la pratique – Playbooks](##partie-5--ansible-par-la-pratique--Playbooks)
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
8. **Déconnectez-vous et supprimez la VM.** :
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

