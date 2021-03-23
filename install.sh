#!/bin/bash
# Dit script installeert de webapp voor het initiatief Nieuwe Energie Overijssel op Ubuntu.
# Getest op 23-03-2021 via AWS Lightsail op Ubuntu v20.04 LTS [STATUS: WERKT]
# Bron: https://www.digitalocean.com/community/tutorials/how-to-install-django-and-set-up-a-development-environment-on-ubuntu-16-04

# CHECK OS
OSsystem=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
if [[ $OSsystem = *"Ubuntu"* ]];then
  echo "Deze server draait op $OSsystem. Geldig.";
  echo ""
else
  echo "Dit systeem draait niet op Ubuntu. De installatie wordt nu beëindigd."
  exit 1;
fi

# VOER WIZARD UIT NA TOESTEMMING GEBRUIKER
echo "In this installation we will install or update the Team Green House webapp, according to the latest Git branch, including all necessary tools (Django, React, Git, Curl) if they do not exists yet. No configuration file will be overwritten."
read -p "Do you want to continue? [y/n] " confirmE
echo ""

if [[ $confirmE != "y" ]]; then
    exit 1;
fi

# ZORG VOOR EEN UP-TO-DATE REPOSITORY
apt-get update

# INSTALLEER PACKAGES ALS ZE NOG NIET ZIJN TOEGEVOEGD
if ! command -v curl &> /dev/null; then
apt-get install -y curl
fi

if ! command -v git &> /dev/null; then
apt-get install -y git
fi

if ! command -v composer &> /dev/null; then
apt-get install -y composer
fi

if ! command -v python &> /dev/null; then
apt-get install -y python3
fi

if ! command -v pip3 &> /dev/null; then
apt-get install -y python3-pip
fi

if ! command -v npm &> /dev/null; then
apt-get install -y npm
fi

if ! command -v django &> /dev/null; then
pip3 install Django
fi

if ! command -v virtualenv &> /dev/null; then
pip3 install virtualenv
fi

# STEL TIMEZONE IN OP AMSTERDAM
timedatectl set-timezone Europe/Amsterdam

# INSTALLEER SCRIPT
# WERKMAP: /opt/webapp/
mkdir -p /opt/webapp
cp -r "$(dirname "${BASH_SOURCE[0]}")/TeamGreenHouse/*" /opt/webapp
chown -R ubuntu:www-data /opt/webapp
chmod -R 755 /opt/webapp
cd /opt/webapp/greenhouse/
npx create-react-app teamgreenhousereact
cd /opt/webapp/greenhouse/teamgreenhousereact
npm run build

# VOEG MESSAGE OF THE DAY TOE
cat > /etc/update-motd.d/97.1-rlzupdate << EOF
#!/bin/sh
echo "#############################################"
echo "Enter 'sudo su'. Then use one of these macro commands:"
echo "# rupdate        # update webapp"
echo "# rcd            # open /opt/webapp/"
#echo "# rdebug         # toon laatste 100 logs van debug.log"
EOF

cat > /etc/update-motd.d/98-diskspace << EOF
#!/bin/sh
echo "#############################################"
echo "# Currently used disk space: "
df -h
EOF

chmod +x /etc/update-motd.d/97.1-rlzupdate
chmod +x /etc/update-motd.d/98-diskspace

# STEL MACRO'S IN
if ! grep -q "rupdate" /root/.bashrc; then
echo "alias rupdate='rm -fr /tmp/Team-Green-House; git clone https://github.com/twanvmeurs/Team-Green-House/ /tmp/Team-Green-House; chown -R ubuntu:www-data /tmp/Team-Green-House && chmod -R 755 /tmp/Team-Green-House; /tmp/Team-Green-House/./install.sh'" >> /root/.bashrc
fi

if ! grep -q "rcd" /root/.bashrc; then
echo "alias rcd='cd /opt/webapp/'" >> /root/.bashrc
fi

#if ! grep -q "rdebug" /root/.bashrc; then
#echo "alias rdebug='tail -100 /var/log/'" >> /root/.bashrc
#fi

# ENV & WEBAPP
# Virtual envoriement is een virtuele omgeving. Binnen die omgeving wordt Django uitgevoerd. De omgeving, samen met Django, wordt gestart door het script run_webapp.sh te draaien bij het opstarten van de server. Hiervoor is een aparte cronjob ontwikkeld die wordt uitgevoerd.
virtualenv -p /usr/bin/python3 /opt/env # MAAK OMGEVING AAN
cat > /opt/run_webapp.sh << EOF
#!/bin/bash
# Binnen dit script wordt de webapp voor het initiatief Nieuwe Energie Overijssel gestart.
# ACTIVEER VIRTUELE OMGEVING
source /opt/env/bin/activate

# INSTALLEER DJANGO ALS NOG NIET BESTAAT
if ! command -v django &> /dev/null; then
pip3 install Django
fi

# VOER DJANGO WEBAPP UIT
python3 /opt/webapp/greenhouse/manage.py runserver 0.0.0.0:80

#Ontwikkeld door Team Green House in 2021.
EOF

crontab -l | grep -q "/opt/run_webapp.sh" && echo 'Cronjob is reeds toegevoegd' || crontab -l | { cat; echo "@reboot chown -R ubuntu:www-data /opt/run_webapp.sh && chmod -R 755 /opt/run_webapp.sh; /opt/run_webapp.sh"; } | crontab -

# FINISHED
echo ""
echo "Installatie voltooid"
echo "Om de webserver handmatig te starten, voer je het volgende command uit:"
echo "python3 /opt/webapp/greenhouse/manage.py runserver 0.0.0.0:80"
exec "$BASH" # RELOAD BASH

#Ontwikkeld door Team Green House in 2021.