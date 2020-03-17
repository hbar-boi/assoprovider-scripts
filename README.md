## Installazione dipendenze

Prima di procedere all'installazione dei pacchetti desiderati occorre eseguire lo 
script in "setup".

$ cd setup
$ sudo ./install.sh

Lo script chiederà username e password con cui configurare l'utente root di MySQL.
Verrà installato Git ed uno stack LAMP.

## Installazione WordPress

Per l'installazione del pacchetto wordpress lanciare lo script in "wordpress"

$ cd wordpress
$ sudo ./install.sh

Lo script chiederà username e password per la creazione di un nuovo utente che
avrà i permessi sul database di wordpress.
Verrà creato un database MySQL con nome "wordpress".
Al completamento dello script navigare su http://localhost/wordpress per completare la
configurazione.

## Installazione Moodle

Per l'installazione di Moodle lanciare lo script in "moodle"

$ cd moodle
$ sudo ./install

Verrà creato un database MySQL "moodle" insieme ad un utente coi permessi su quest'ultimo.
Al termine dello script navigare su http://localhost/moodle per completare la configurazione
