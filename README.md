# Assoprovider-scripts

## Installazione

### Procedura guidata di installazione

Dalla root di questo repository eseguire `install.sh`, lo script chiederá le informazioni necessarie

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
