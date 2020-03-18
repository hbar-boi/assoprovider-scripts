# Assoprovider-scripts

## Installazione

### Procedura guidata di installazione

Dalla root di questo repository eseguire `install.sh`, lo script chiederรก le informazioni necessarie

### Installazione singoli componenti

#### Moodle

- Installare Docker con `sudo sh docker/install.sh`
- Installare Moodle con `cd moodle-docker && sudo sh install.sh`

#### Wordpress

- Installare Docker con `sudo sh docker/install.sh`
- Installare WordPress con `cd wordpress-docker && sudo sh install.sh`

## Manutenzione

### Accesso ai log

- __Moodle__: `sudo journalctl -u moodle.service`
- __WordPress__: `sudo journalctl -u wordpress.service`

## Testing in locale

- Avviare la VM di sviluppo con `vagrant up`
- Entrare nella VM di sviluppo con `vagrant ssh`
- Entrare nella cartella del progetto con `cd /vagrant`
- Lanciare lo script di installazione con `./install.sh`

La porta `80 (HTTP)` ? accessibile sulla porta host `8080`
La porta `443 (HTTPS)` ? accessibile sulla porta host `8443`

### Virtual host

Per provare i virtual host utilizzare `xip.io` o `nip.io`

Ad esempio: impostando `wordpress.127.0.0.1.nip.io` come dominio per WordPress si potr? accedere a WordPress andando su `http://wordpress.127.0.0.1.nip.io:8080`
