#!/bin/sh
set -e # Fallisci in caso di errore

#
# Root check
#

if [ "$(id -u)" != "0" ]; then
  echo 'Lancia come root' > /dev/stderr && exit 1
fi

#
# Docker check
#

if ! [ -x "$(command -v docker)" ]; then
  echo "Installare Docker" > /dev/stderr && exit 1
fi

#
# Ask for credentials
#

# Import existing settings
if [ -f .env ]; then
  . ./.env
fi

if [ -z "$DB_PASS" ]; then
  while [ -z "$DB_PASS" ]; do
    printf 'Database password? ' && read -r DB_PASS
  done
  echo "DB_PASS=$DB_PASS" >> .env
fi

if [ -z "$VIRTUAL_HOST" ]; then
  while [ -z "$VIRTUAL_HOST" ]; do
    printf 'Dominio? ' && read -r VIRTUAL_HOST
  done
  echo "VIRTUAL_HOST=$VIRTUAL_HOST" >> .env
fi

if [ -z "$MOODLE_USERNAME" ]; then
  while [ -z "$MOODLE_USERNAME" ]; do
    printf 'Username di Moodle? ' && read -r MOODLE_USERNAME
  done
  echo "MOODLE_USERNAME=$MOODLE_USERNAME" >> .env
fi

if [ -z "$MOODLE_PASSWORD" ]; then
  while [ -z "$MOODLE_PASSWORD" ]; do
    printf 'Password di Moodle? ' && read -r MOODLE_PASSWORD
  done
  echo "MOODLE_PASSWORD=$MOODLE_PASSWORD" >> .env
fi

if [ -z "$MOODLE_EMAIL" ]; then
  while [ -z "$MOODLE_EMAIL" ]; do
    printf 'Email di Moodle? ' && read -r MOODLE_EMAIL
  done
  echo "MOODLE_EMAIL=$MOODLE_EMAIL" >> .env
fi


if [ -z "$SMTP_HOST" ] && [ -z "$NO_EMAIL" ]; then
  printf "Desideri configurare l'invio delle email (s/N)? " && read -r MAIL_QUESTION
  if [ "$MAIL_QUESTION" = "S" ]; then

    if [ -z "$SMTP_HOST" ]; then
      while [ -z "$SMTP_HOST" ]; do
        printf 'Indirizzo del server di posta in uscita? ' && read -r SMTP_HOST
      done
      echo "SMTP_HOST=$SMTP_HOST" >> .env
    fi

    if [ -z "$SMTP_PORT" ]; then
      while [ -z "$SMTP_PORT" ]; do
        printf 'Porta del server di posta in uscita? ' && read -r SMTP_PORT
      done
      echo "SMTP_PORT=$SMTP_PORT" >> .env
    fi

    if [ -z "$SMTP_USER" ]; then
      while [ -z "$SMTP_USER" ]; do
        printf 'Username sul server di posta in uscita? ' && read -r SMTP_USER
      done
      echo "SMTP_USER=$SMTP_USER" >> .env
    fi

    if [ -z "$SMTP_PASSWORD" ]; then
      while [ -z "$SMTP_PASSWORD" ]; do
        printf 'Password sul server di posta in uscita? ' && read -r SMTP_PASSWORD
      done
      echo "SMTP_PASSWORD=$SMTP_PASSWORD" >> .env
    fi

    if [ -z "$SMTP_PROTOCOL" ]; then
      while [ -z "$SMTP_PROTOCOL" ]; do
        printf 'Protocollo del server di posta (ssl / tls)? ' && read -r SMTP_PROTOCOL
      done
      echo "SMTP_PROTOCOL=$SMTP_PROTOCOL" >> .env
    fi

  else
    echo "NO_EMAIL=y" >> .env
  fi
fi

#
# Setup service
#
cat > /etc/systemd/system/moodle.service <<EOF
[Unit]
Description = Moodle in Docker

Requires = docker.service
After = docker.service

[Service]
ExecStartPre = $(command -v docker-compose) pull --ignore-pull-failures
ExecStart = $(command -v docker-compose) up --remove-orphans

TimeoutStartSec = 0s

WorkingDirectory = $(pwd)

[Install]
WantedBy = multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now moodle.service
