#!/bin/bash

if [ -d ~/.linuxbrew ]; then
  PATH=/usr/bin:$PATH
fi

[[ -d .venv ]] && source .venv/bin/activate

NAME=laufer
MAIN=cv-main
FULLNAME="Konstantin Läufer"
GITHUB_USER=klaeufer
DOMAIN=${GITHUB_USER}.github.io
