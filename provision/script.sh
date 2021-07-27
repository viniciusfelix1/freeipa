#!/bin/bash

DOMAIN="4labs.example"
IPA_IP="192.168.99.10"

# Variaveis opcionais
## Se não definir as senhas, serão geradas senhas aleatórias.
# ADMIN_PW=""
# DM_PW=""

# ---

server(){
  sed -ri 's/127.0.1.1.*//g' /etc/hosts
  echo -e "${IPA_IP}\t${HOSTNAME}.${DOMAIN}\t${HOSTNAME}" | sudo tee -a /etc/hosts
  sudo hostnamectl set-hostname ${HOSTNAME}.${DOMAIN}
  yum install epel-release -y
  yum install ipa-server ipa-server-dns -y
  REALM=$(echo "$DOMAIN" | tr [:lower:] [:upper:]])
  ipa-server-install -U --ds-password=${DM_PW} --realm=${REALM} --admin-password=${ADMIN_PW} --domain=${DOMAIN} --hostname=${HOSTNAME}.${DOMAIN} --setup-dns --no-host-dns --allow-zone-overlap --forwarder=8.8.8.8 --forwarder=1.1.1.1 --no-dnssec-validation
}

client(){
  echo -e "${IPA_IP} ipa.${DOMAIN} ipa" | sudo tee -a /etc/hosts
  echo -e "${IP}\t${HOSTNAME}.${DOMAIN}\t${HOSTNAME}" | sudo tee -a /etc/hosts
  sudo hostnamectl set-hostname ${HOSTNAME}.${DOMAIN}
  yum -y install freeipa-client
}

pw() {
  if [ ! -z "$ADMIN_PW" ]; then
    echo "A senha do usuário admin foi definida através da variável. (Senha: ${ADMIN_PW})"
  else
    ADMIN_PW=$(openssl rand -base64 10 | tr -d '=/')
    echo -e "A senha do usuário admin foi gerada de forma aleatória, armazene em um local seguro. \n\tSenha: ${ADMIN_PW}\n" | tee ~/ipa-pass
  fi

  if [ ! -z "$DM_PW" ]; then
    echo "A senha do usuário admin foi definida através da variável. (Senha: ${DM_PW})"
  else
    DM_PW=$(openssl rand -base64 10 | tr -d '=/')
    echo -e "A senha do Directory Manager foi gerada de forma aleatória, armazene em um local seguro. \n\tSenha: ${DM_PW}" | tee -a ~/ipa-pass
  fi
}

# ---

IP=$(ip a | awk '/192/ {print $2}' | sed -r 's,/.{2},,')

if [ $HOSTNAME == "ipa" ]; then
  pw
  server
else
  client
fi

