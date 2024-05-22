#!/bin/bash

		### Parcours du fichier CSV ###
#Hero Instance
while IFS=',' read -r id name hp mp str int def res spd luck race class rarity;
do
        if [[ $id = 1 ]]
        then
	name_perso=$name
        hp_hero=$hp
	str_hero=$str
        fi
done < ../players.csv

#random_enemy Instance
while IFS=',' read -r id name hp mp str int def res spd luck race class rarity;
do
        if [[ $name == Bokoblin ]]
        then
                enemy_name=$name
                enemy_hp=$hp
                enemy_str=$str
        fi
done < ../enemies.csv

#Enemy Boss Instance
while IFS=',' read -r id name hp mp str int def res spd luck race class rarity;
do
        if [[ $name == Ganon ]]
        then
                boss_name=$name
                boss_hp=$hp
                boss_str=$str
        fi
done < ../bosses.csv




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
	boss_remaining_hp=$((boss_remaining_hp - $str_hero))
}

#Attacking basic enemies
my_attack_basic_enemies()
{
        enemy_remaining_hp=$((enemy_remaining_hp - $str_hero))
	echo "Vous avez enlevé $str_hero points de vie à l'ennemi"
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
	hero_remaining_hp=$((hero_remaining_hp - $enemy_str))
	echo -e "\nLe sbire vous attaque! Vous avez perdu $enemy_str points de vie \n"
}

#boss attacks
boss_attacks()
{
        hero_remaining_hp=$((hero_remaining_hp - $boss_str))
        echo -e "Vous avez perdu $boss_str points de vie \n"
}

floor=1
while [[ $floor -lt 10 ]]
do
	hero_remaining_hp=$hp_hero
	enemy_remaining_hp=$enemy_hp
	echo "Vous avez rencontre un $enemy_name"
	echo -e "\t\t\t============= Etage $floor ===============\t\t\t"
	cpt=1
	while [[ $enemy_remaining_hp -gt 0 ]]
	do
		if [[ $hero_remaining_hp -gt 0 ]]
		then
			echo -e "\n\tTOUR $cpt \n"
			echo "Your Hero : $name_hero  HP : $hero_remaining_hp"
			hero_life
			echo "Your Enemy : $enemy_name HP : $enemy_remaining_hp"
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
        hero_remaining_hp=$hp_hero
        boss_remaining_hp=$hp_boss
	echo -e "\t\t\t============= Etage $floor ===============\t\t\t"
	echo -e "\n  Préparez-vous à affronter le boss final  \n"
        cpt=1
	while [[ $boss_remaining_hp -gt 0 ]]
        do
        	if [[ $hero_remaining_hp -gt 0 ]]
                then
                        echo -e "\n\tTour $cpt \n"
                        echo "Your Hero : $name_hero  HP : $hero_remaining_hp"
                        hero_life
                        echo "The Final Boss : $boss_name HP : $boss_remaining_hp"
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
