#!/usr/bin/env bash

# set -x

####PERRUDO SRV####

#### Initialisation des variables ####
#nombre d'utilisateurs connectés
# userco=`who | wc -l`
nomjoueur=`whoami`
#numerotation des lignes
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

######################################
############FONCTIONS#################
######################################

userco_nb()
{
	userco=`ps aux | grep webudo_clt | grep -v grep | awk '{ print $1 }' | sort -u | wc -l`	
}

userco_nom()
{
	ps aux | grep webudo_clt | grep -v grep | awk '{ print $1 }' | sort -u	
}

clean_up()	
{
	mkdir /tmp/webudo 2> /dev/null
	rm -f /tmp/webudo/webudo_*
	clear
	stop_proc_webudo_clt
}

stop_proc_webudo_clt()
{
	userco_nb
	while [ ${userco} -gt 0 ] ; do
			userco_nb	
			echo "${Green}Plusieurs webudo_clt sont lancés${ResetColor}"
			echo "${Green}Que souhaitez vous faire ? : ${ResetColor}"
			echo "${Green}1) Les stopper${ResetColor}"
			echo "${Green}2) Continuer${ResetColor}"
			echo "${Green}3) Quitter le jeu ${ResetColor}"
			echo "${Green}4) Afficher les scripts lancés ${ResetColor}" 
			# ${line} $((14+${userco})) 0
			read -p "${Green}votre choix : ${ResetColor}" choix1			
			case "${choix1}" in
					1) while true ; do 
						  sudo pkill -KILL webudo_clt.sh
						  if [ $? -eq 1 ] ; then 
						  break 
						  fi
						  done
						  break
						  ;;
					2) break  ;;
					3) exit ;;
					4) echo ${Red} 
					   userco_nom
					   echo ${ResetColor}
					   ;;
					*) echo "1, 2 ou 3 ! merci !" ;;	
			esac
	done
}

display_header()
{
	userco_nb
	# ${line} 0 20
	echo -e "${Blue}##########################################${ResetColor}"
	# ${line} 1 20
	echo -e "${Green}#         Bienvenue dans WEBUDO !!!         #${ResetColor}"
	# ${line} 2 21
	echo -e "${Green}#         `echo ${userco} "joueurs connectés"`            #${ResetColor}"	 
	# ${line} 3 20
	echo -e "${Blue}##########################################${ResetColor}"
}

get_nb_player()
{
	while true ; do
	clear
	display_header
	${line} 4 0
	echo -n "${Red}Mettre un chiffre entre 2 et 6 please ! ${ResetColor}"
	read -r nbjoueurs
	echo "${nbjoueurs}" | grep -e '^[[:digit:]][[:digit:]]*$'  > /dev/null ;	# entrée envoi ^$ / * = The preceding item will be matched zero or more times 
	 	if ! [ $? -eq 0 ]  
	 		then 				
	 			echo "${Red}Un chiffre${ResetColor}"				
	 			sleep 2 			
					elif [ "${nbjoueurs}" -gt 6 ] 
						then 
							echo -en "${Red}Attention tu ne peux pas jouer à plus de 6 !!${ResetColor}\r"
							${line} 4 0
							sleep 2 
								elif [ "${nbjoueurs}" -eq 1 ] || [ "${nbjoueurs}" -eq 0 ] 
									then 
										echo -n "${Red}Plus de 1, merci !!${ResetColor}"
										sleep 2
			else
				break
		fi
	done
}

#Verif si sup à 1 et sup à userco
verif_gt_userco()
{
	userco_nb
	if [ "${nbjoueurs}" -gt "${userco}" ] ; then
		# ${line} 6 0	
		echo "${Green}${userco} joueurs connectés : "  
		# ${line} 7 0	
		echo ${Green}
		userco_nom
		${ResetColor}
		# ${line} $((8+${userco})) 0
		echo "${Green}Que souhaitez vous faire ? : ${ResetColor}"
		echo "${Green}1) Attendre d'autre joueur ${ResetColor}"
		echo "${Green}2) Redefinir le nombre de joueurs ${ResetColor}"
		echo "${Green}3) quitter le jeu ${ResetColor}" 
		# ${line} $((14+${userco})) 0
		read -p "${Green}votre choix : ${ResetColor}" choix1			
		case "${choix1}" in
				1) wait_player ;;
				2) get_nb_player ;;
				3) exit ;;
				*) echo "1, 2 ou 3 ! merci !" ;;			
		esac
	fi
}

verif_lt_userco()  
{  
	userco_nb
	if [ "${nbjoueurs}" -gt 1 ] && [ "${nbjoueurs}" -lt "${userco}" ] ; then
		echo "${Green}${userco} joueurs connectés ;)${ResetColor}"
		echo -n ${Red} 
		userco_nom 
		echo -n ${ResetColor}
		echo "${Blue}Que souhaitez vous faire ?${ResetColor}"  
		echo "${Green}1) Deconnecter un joueur${ResetColor}" 
		echo "${Green}2) Redefinir le nombre de joueurs ${ResetColor}" 
		echo "${Green}3) quitter le jeu ${ResetColor}" 
		read -p "${Green}votre choix : ${ResetColor}" choix2
			case "${choix2}" in
				1) deco_joueur ;;
				2) get_nb_player ;;
				3) exit ;;
				*) echo "1, 2 ou 3 ! merci !" ;;
			esac
	fi		
}

verif_eq_userco()
{
	userco_nb
	if	[ ${nbjoueurs} -gt 1 ] && [ ${nbjoueurs} -eq ${userco} ]  
		then
			init_sub_sys
			start_game
	fi
}		

deco_joueur() 
{
	echo `who | cut -d" " -f1 | sort -u`
	read -p "${Green}nom du joueur à deconnecter : ${ResetColor}" nompts
	`sudo pkill -KILL -u ${nompts}`
	get_nb_player
}

wait_player()
{
	while true ; do
	userco_nb
	[ ${userco} -eq ${nbjoueurs} ] && break
	echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs, merci |\r" 
	sleep 0.5  
	echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs, merci /\r"
	sleep 0.5 
	echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs, merci -\r"
	sleep 0.5 
	echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs, merci |\r"
	sleep 0.5 
	echo  -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs, merci -\r"
	sleep 0.5 
	echo -en "${userco} joueur(s) connecté(s) ! En attente des autres joueurs, merci \\ \r"   
	sleep 0.5 
	done
	echo "${Green}Tous les joueurs sont connectés${ResetColor}"
	echo "${Green}Initialisation la partie !${ResetColor}"
}

start_game() 
{
	userco_nb
	# ${line} 7 28
	echo "${BlueCyan}NB joueurs connectés : ${userco}${ResetColor}"
	# ${line} 8 28
	echo "${BlueCyan}NB joueurs selectionné : ${nbjoueurs}${ResetColor}"
	# ${line} 9 28
	echo "${Green}Tous les Joueurs sont operationnels${ResetColor}"	
	sleep 1
	# ${line} 10 28
	echo "${Green}Definition du premier joueur à commencer ${ResetColor}" 
	firstplayer
}

init_sub_sys() 
{
	if ! [ -d /tmp/webudo ]
		then 
			mkdir /tmp/webudo
		else
			for f in $(userco_nom) ; do
				if  [ ! -e /tmp/webudo/webudo_${f} ]
					then
					mkfifo /tmp/webudo/webudo_${f}	
				fi
				sleep 1
			done
	fi
}

#Initialise le tableau du nom des users	
array_users() 
{
	a=0	
	for u in `ps aux | grep webudo_clt | grep -v grep | awk '{ print $1 }' | sort -u` ; do
			array_nom[${a}]="${u}"
			a=$(($a+1))
	done
	echo ${array_nom[*]} > /$HOME/perudo/users
}

#Definit le premier joueur
firstplayer() 
{
	array_users
	# ${line} 11 28
	echo "${Green}Qui sera le premier joueur ?${ResetColor}"	
	# random sur valeur du tableau
	f=$(echo $((RANDOM%`cat users | wc -w`))) 
	first=$(echo "${Green}${array_nom[${f}]}${ResetColor}")
	echo ${first}
	echo ${first} > first_player
	sleep 20
}



#######CODE#######
clean_up

get_nb_player

verif_gt_userco

verif_lt_userco

verif_eq_userco

