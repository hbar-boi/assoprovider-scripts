#!/bin/sh
set -e

# Funzioni
runInstallScript() {
  # Fa cd dentro alla cartella $1 e esegue install.sh
  cd "$1" || exit 1
  ./install.sh
  cd ..
}

runDockerInstallScript() {
  # Installa Docker e poi invoca install.sh
  ./docker/install.sh
  runInstallScript "$1"
}

askInstall() {
  # Chiede di installare il prodotto della cartella $1, chiamandolo $2
  printf 'Desideri installare %s (S/n)? ' "$2" && read -r REPLY

  if [ -z "$REPLY" ] || [ "$REPLY" = "S" ]; then
    if [ -f "$1/docker-compose.yml" ]; then
      runDockerInstallScript "$1"
    else
      runInstallScript "$1"
    fi
  fi
}

# Rende tutti gli script eseguibili
find . -type f -name '*.sh' -print0 | xargs -r -0 chmod +x

# Chiede di installare
askInstall 'moodle-docker' "Moodle"
askInstall 'wordpress-docker' "Wordpress"
