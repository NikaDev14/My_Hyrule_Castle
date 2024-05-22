#!/bin/bash

		### Creation des trois personnages ###
#Link Instance
declare -A hero=(
		[name]=Link
		[hp]=60
		[str]=15
		)

#Boboklin
declare -A enemy=(
                [name]=Bokoblin
                [hp]=30
                [str]=5
                )

#Ganon
declare -A boss=(
                [name]=Ganon
                [hp]=150
                [str]=20
                )


		### Fonctions basiques ###

#Display life

hero_life()
{
	ch=""
	for((i=0; i<=$hero_remaining_hp; i++));
	do
		ch+="*"
	done
	echo "$ch"
}

enemy_life()
{
	ch=""
        for((i=0; i<=$enemy_remaining_hp; i++));
        do
                ch+="*"
        done
        echo -e "$ch\n"
}

boss_life()
{
        ch=""
        for((i=0; i<=$boss_remaining_hp; i++));
        do
                ch+="*"
        done
        echo -e "$ch\n"
}

#Attacking boss
my_attack_boss()
{
	boss_remaining_hp=$((boss_remaining_hp - ${hero[str]}))
}

#Attacking basic enemies
my_attack_basic_enemies()
{
        enemy_remaining_hp=$((enemy_remaining_hp - ${hero[str]}))
	echo "Vous avez enlevé ${hero[str]} points de vie à l'ennemi"
}

#Healing
heal()
{
	if [[ $hero_remaining_hp -lt 60 ]]
	then
		hero_remaining_hp=$((hero_remaining_hp+30))
		if [[ hero_remaining_hp -gt 60 ]]
		then
			hero_remaining_hp=60
		fi
		echo -e "Vous vous êtes soignés\n"
	else
		echo -e "Vous êtes déjà en excellente forme\n"
	fi
}

#basic enemies' attack
basic_attacks()
{
	hero_remaining_hp=$((hero_remaining_hp - ${enemy[str]}))
	echo -e "\nLe sbire vous attaque! Vous avez perdu ${enemy[str]} points de vie \n"
}

#boss attacks
boss_attacks()
{
        hero_remaining_hp=$((hero_remaining_hp - ${boss[str]}))
        echo -e "Vous avez perdu ${boss[str]} points de vie \n"
}

floor=1
while [[ $floor -lt 10 ]]
do
	hero_remaining_hp=${hero[hp]}
	enemy_remaining_hp=${enemy[hp]}
	echo "Vous avez rencontre un ${enemy[name]}"
	echo -e "\t\t\t============= Etage $floor ===============\t\t\t"
	cpt=1
	while [[ $enemy_remaining_hp -gt 0 ]]
	do
		if [[ $hero_remaining_hp -gt 0 ]]
		then
			echo -e "\n\tTOUR $cpt \n"
			echo "Your Hero : ${hero[name]}  HP : $hero_remaining_hp"
			hero_life
			echo "Your Enemy : ${enemy[name]} HP : $enemy_remaining_hp"
			enemy_life
			echo -e "Voulez-vous attaquer ou bien vous soigner? \n\n"
			echo -e "\t\t 1-Attaquer \t\t\t 2-Soins\t\t \n\n"
			answer=0
			read answer
			if [[ $answer -eq 1 ]]
			then
				my_attack_basic_enemies
			elif [[ $answer -eq 2 ]]
			then
				heal
			else
				echo "Cette touche n'est pas reconnue..."
			fi
			if [[ $enemy_remaining_hp -gt 0 ]]
			then
				basic_attacks
				cpt=$((cpt+1))
			else
				continue
			fi
		else
			echo "Vous etes mort! A bientot pour une nouvelle chance"
			exit
		fi
	done
	echo -e "Félicitations! L'ennemi est KO \n"
	read -p "Press enter to continue"
	floor=$((floor+1))
done

while [[ $floor -eq 10 ]]
do
        hero_remaining_hp=${hero[hp]}
        boss_remaining_hp=${boss[hp]}
	echo -e "\t\t\t============= Etage $floor ===============\t\t\t"
	echo -e "\n  Préparez-vous à affronter le boss final  \n"
        cpt=1
	while [[ $boss_remaining_hp -gt 0 ]]
        do
        	if [[ $hero_remaining_hp -gt 0 ]]
                then
                        echo -e "\n\tTour $cpt \n"
                        echo "Your Hero : ${hero[name]}  HP : $hero_remaining_hp"
                        hero_life
                        echo "The Final Boss : ${boss[name]} HP : $boss_remaining_hp"
                        boss_life
                        echo -e "Voulez-vous attaquer ou bien vous soigner? \n\n"
                        echo -e "\t\t 1-Attaquer \t\t\t 2-Soins\t\t \n\n"
                        answer=0
			read answer
                        if [[ $answer -eq 1 ]]
                        then
                                my_attack_boss
                        elif [[ $answer -eq 2 ]]
                        then
                                heal
                        else
                                echo "Cette touche n'est pas reconnue..."
                        fi
                        if [[ $boss_remaining_hp -gt 0 ]]
                        then
                                boss_attacks
                                cpt=$((cpt+1))
                        else
                                continue
                        fi
                else
                        echo "Vous etes mort! A bientot pour une nouvelle chance"
                        exit
                fi
        done
        echo -e "\n\t\t\t BRAVO! Vous avezz battu le boss final!!!\t\t\t"
	exit
done
