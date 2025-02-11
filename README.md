# Exo 1 : Ansible par la pratique

## Installation

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

# Exo 2 : Installation d'Ansible via un PPA
