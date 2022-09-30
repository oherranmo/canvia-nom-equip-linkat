#!/bin/bash
#Autor: Òscar Herrán Morueco
check_root()
{
if [ "$(id -u)" != "0" ]; then
	whiptail --title "Error!" \
    --msgbox "Heu d'executar aquest script com a root (sudo) > ./nomscript.sh" 10 30
	exit 1
fi
start
}

start()
{

if(whiptail  --title "Confirmació" \
    --yesno "Voleu canviar el nom de l'equip ara?" \
    --yes-button "Si" \
    --no-button "No" 10 60) then
escriu_hostname
else
echo "Operació avortada per l'usuari"
exit 1
fi
}

escriu_hostname()
{

HNAME=$(whiptail --title "Nom de l'equip" \
    --inputbox "Escriviu el nou nom de l'equip" 10 60 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
if [ -z $HNAME ]; then
	whiptail --title "Error!" \
    --msgbox "Introduïu un nom d'equip" 10 30
escriu_hostname
else
hostnamectl set-hostname $HNAME
# PATH TO YOUR HOSTS FILE
ETC_HOSTS=/etc/hosts

# DEFAULT IP FOR HOSTNAME
IP="127.0.1.1"

# Hostname to add/remove.
HOSTNAME=$HNAME

    if [ -n "$(grep $IP /etc/hosts)" ]
    then
        echo "$IP S'ha trobat $ETC_HOSTS, Suprimint...";
        sudo sed -i".bak" "/$IP/d" $ETC_HOSTS
        
    else
        echo "No s'ha trobat $IP al fitxer $ETC_HOSTS";
        
    fi
    HOSTS_LINE="$IP\t$HOSTNAME"
    if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
        then
            echo "$HOSTNAME ja existeix : $(grep $HOSTNAME $ETC_HOSTS)"
        else
            echo "Afegint $HOSTNAME al fitxer $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

            if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
                then
                    echo "$HOSTNAME s'ha afegit correctament \n $(grep $HOSTNAME /etc/hosts)";
                else
                clear
	whiptail --title "Error!" \
    --msgbox "No s'ha pogut canviar correctament el nom de l'equip, reviseu el fitxer /etc/hosts i /etc/hostname" 10 60
            fi
    fi
$@
reiniciar
fi
else
echo "Operació avortada per l'usuari"
exit 1
fi

}


reiniciar()
{

if(whiptail  --title "Reinici" \
    --yesno "Voleu reiniciar l'equip per a aplicar tots els canvis ara?" \
    --yes-button "Si" \
    --no-button "No" 10 60) then
reboot
else
echo "Ha finalitzat el canvi d'equip a $HNAME"
exit 1
fi

}
check_root
