# FreeIPA

Neste repo você encontra os arquivos necessários para subir uma servidor do FreeIPA e um cliente através do vagrant.

O serviço do FreeIPA é provisionado ao rodar `vagrant up`. Do lado do cliente, é instalado somente o pacote, para fazer a inserção do cliente é necessário primeiramente coletar a senha do usuário admin do IPA, esta senha disponível no arquivo "ipa-pass" na home do usuário root no servidor IPA e então rodar os seguintes comandos:

```bash
sudo hostnamectl set-hostname centos.4labs.example
sudo sed -ri 's,(nameserver).*,\1 192.168.99.10,' /etc/resolv.conf
sudo ipa-client-install -U --mkhomedir --force-ntpd --server=ipa.4labs.example --domain=4labs.example --realm=4LABS.EXAMPLE -padmin -w${ADMIN_PW} --enable-dns-updates
``` 

## How to use

```bash
git clone https://github.com/viniciusfelix1/freeipa.git
cd freeipa
vagrant up
```
E também é necessário mapear no `/etc/hosts` a seguinte entrada `192.168.99.10 ipa.4labs.example`.
