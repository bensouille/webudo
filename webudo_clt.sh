#!/usr/bin/env bash
set -x
####PERRUDO !!!####

#Variables globales du jeu
JOUEUR=`whoami`
DES1=$((RANDOM%6+1))
DES2=$((RANDOM%6+1))
DES3=$((RANDOM%6+1))
DES4=$((RANDOM%6+1))
DES5=$((RANDOM%6+1))
#### Initialisation des variables ####

line='tput cup'

#+ Mode normal
ResetColor="$(tput sgr0)"
# "Surligné" (bold)
bold="$(tput smso)"
# "Non-Surligné" (offbold)
offbold="$(tput rmso)"

# Couleurs (gras)
#+ Rouge
Red="$(tput bold ; tput setaf 1)"
#+ Vert
Green="$(tput bold ; tput setaf 2)"
#+ Jaune
Yellow="$(tput bold ; tput setaf 3)"
#+ Bleue
Blue="$(tput bold ; tput setaf 4)"
#+ Cyan
BlueCyan="$(tput bold ; tput setaf 6)"


#### Fin initialisation variables ####

clean_up()	
{
	rm -f /tmp/webudo/webudo_`whoami`
	clear
}

#Attente de lancement de la partie et affichage msg serveur
verif_proc_srv_clt_nbfifo()
{
	srvco=`ps aux | grep webudo_main | sort -u | grep -v grep | wc -l `
	userco=`ps aux | grep webudo_clt | grep -v grep | awk '{ print $1 }' | sort -u | wc -l`
	nbfifo=`find /tmp/webudo/ -type p | wc -l`	
}

verif_srvco_userco_sup_nbfifo()
{
	[ ${srvco} -gt 0 ] && [ ${userco} -eq ${nbfifo} ] && break
}

wait_clt()
{
	while true ; do
		verif_proc_srv_clt_nbfifo
		verif_srvco_userco_sup_nbfifo
		echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs et du serveur, merci |\r" 
		verif_proc_srv_clt_nbfifo
		verif_srvco_userco_sup_nbfifo 
		echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs et du serveur, merci /\r"
		verif_proc_srv_clt_nbfifo
		verif_srvco_userco_sup_nbfifo 
		echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs et du serveur, merci -\r"
		verif_proc_srv_clt_nbfifo
		verif_srvco_userco_sup_nbfifo 
		echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs et du serveur, merci |\r"
		verif_proc_srv_clt_nbfifo
		verif_srvco_userco_sup_nbfifo 
		echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs et du serveur, merci -\r"
		verif_proc_srv_clt_nbfifo
		verif_srvco_userco_sup_nbfifo
		echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs et du serveur, merci \\ \r"
	done
}

nom_joueur() 
{
# Affiche le nom du joueur
	tput cup 3 31
	echo "${Red}  Bonjour ${JOUEUR} ${ResetColor}"
	echo "${Green}Bienvenu dans WEBUDO !! ${ResetColor}"
	echo "${BlueCyan}Ici on ne dit pas Paco mais Aro"

}


start() 
{
	echo -en "En attente du serveur\r"
	while true ; do
	echo -en "En attente du serveur\r"
	[ -p /tmp/webudo/webudo_`whoami` ] && break 
	done
	sleep 5
	dice_drawing_color
}

# num_tour()
# {

# }

dice_drawing() 
{
	# lancé de dés
	echo  "Tour n"
	echo  "$(if [ ${DES1} = 1 ] ; then echo @ ; else echo ${DES1} ; fi) $(if [ ${DES2} = 1 ] ; then echo @ ; else echo ${DES2} ; fi) $(if [ ${DES3} = 1 ] ; then echo @ ; else echo ${DES3} ; fi) $(if [ ${DES4} = 1 ] ; then echo @ ; else echo ${DES4} ; fi) $(if [ ${DES5} = 1 ] ; then echo @ ; else echo ${DES5} ; fi)"
}

dice_drawing_color() 
{
	dice_drawing > dice_ascii_`whoami`
	toilet -tf mono12 --gay < dice_ascii_`whoami` 
}
# function veriftour () {
# if 

# }

# premier() 
# {
# Premiere annonce du premier joueur
# tput cup 8 27
# echo "${Green}Que souhaites-tu annoncer ?${ResetColor}"
# tput cup 9 23
# echo "${Green}Exemples : 2D2 ou 3d5 ou 46 ou 6.4${ResetColor}"
# tput cup 10 0
# echo "${Red}ATTENTION !!! Au premier tour tu n'as pas le droit d'utiliser les webudo !!!${ResetColor}"
# tput cup 11 0

# if [ -a /tmp/perudo/tour ] ; then
	# cat < ${tour}
# else
	# while read -p "${Green}Ton choix : ${ResetColor}" option1; do
		# echo -n "${Red}Ton choix est${ResetColor} "
	# echo "${option1}" | grep -e '^[[:digit:]]*D[[:digit:]]$' > /dev/null || 
	# echo "${option1}" | grep -e '^[[:digit:]]*d[[:digit:]]$' > /dev/null || 
	# echo "${option1}" | grep -e '^[[:digit:]]*[[:digit:]]$' > /dev/null || 
	# echo "${option1}" | grep -e '^[[:digit:]]*\.[[:digit:]]$' > /dev/null

		# if [ $? -eq 0 ] ; then 
			# echo "${Green}OK${ResetColor}" && break
 		# else 
	 		# echo -n "${Red}mauvais, attention à la syntaxe ! Repeat again : ${ResetColor}" ; 
		# fi
		 # 
	# done
# fi
# }


#Code

clean_up

wait_clt

nom_joueur

start

# start

# lance

# premier

# tourpartour



