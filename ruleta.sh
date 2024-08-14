#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

ctrl_c() {
    echo -e "\n\n${redColour}[!] Saliendo... ${endColour}\n"
    tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

helpPanel(){
    echo -e "\n${blueColour}Ayuda:${endColour} Utiliza este script como sigue:\n"
    echo -e "\t${blueColour}-m <dinero>${endColour} ${grayColour}: Especifica la cantidad de dinero que deseas para jugar.${endColour}\n"
    echo -e "\t${blueColour}-t <técnica>${endColour} ${grayColour}: Técnica a utilizar.${endColour}${purpleColour}(martingala/inverseLabrouchere)${endColour}\n"
    exit 1
}


martingala(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual ${endColour}${yellowColour}$money€${endColour}"
    echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero tienes pensado apostar? -->${endColour} " && read initial_bet
    echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? --> ${endColour}" && read par_impar

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inical de${endColour} ${yellowColour}$initial_bet€${endColour}${grayColour} a${endColour} ${yellowColour}$par_impar${endColour}"
    
    backup_bet=$initial_bet
    COUNTER=0
    jugadas_malas=""
    max_money=0

    tput civis # Ocultar el cursor
    while true; do
    money=$(($money - $initial_bet))

#   echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour} ${yellowColour}$initial_bet€${endColour}${grayColour} y tienes${endColour} ${yellowColour}$money€${endColour}"
#   random_numer="$(($RANDOM % 37))"
    randon_numer="$(shuf -i 0-36 -n1)"
    let COUNTER++ # contador total de jugadas
#   echo -e "${yellowColour}[+]${endColour}${grayColour} Has perdido${endColour} ${blueColour}$jugadas_malas${endColour} ${grayColour}rondas${endColour}"
    
#    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour}${blueColour} $randon_numer${endColour}"
        if [ ! "$money" -lt 0 ]; then  # Si el dinero apostado es mayor de cero
            if [ "$par_impar" == "par" ]; then # si apostamos al numero par
                if [ "$(($randon_numer % 2))" -eq 0  ]; then # Si el numero aleatorio es un numero par
                    if [ "$randon_numer" -eq 0 ]; then # Si el numero aleatorio es igual que cero la apuesta se duplica
#                       echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el${endColour} ${blueColour}0${endColour}${grayColour}, por tanto ${endColour}${redColour}¡pierdes!${endColour}"
                        initial_bet=$(($initial_bet*2))
                        jugadas_malas+="$randon_numer " #Almacena el valor del numero aleatorio que salio impar
#                       echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour} ${yellowColour}$money€${endColour}"
                    else  # Si el numero es par ganas      
#                       echo -e "${yellowColour}[+]${endColour}${grayColour} El número que ha salido es par,${endColour} ${greenColour}¡ganas!${endColour}"
                        reward=$(($initial_bet*2))
#                       echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour} ${yellowColour}$reward€${endColour}"
                        money=$(($money+$reward))
#                       echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour} ${yellowColour}$money${endColour}"
                        initial_bet=$backup_bet
                        jugadas_malas=""
                        max_money=$money
                    fi
                else # Si es un numero impar, la apuesta se duplica
#                    echo -e "${yellowColour}[+]${endColour}${grayColour} El número ha salido impar.${endColour} ${redColour}¡pierdes!${endColour}"
                    initial_bet=$(($initial_bet*2))
#                    echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour} ${yellowColour}$money€${endColour}"
                    jugadas_malas+="$randon_numer "
                fi
            else # Si apostamos al numero impar
                if [ "$(($randon_numer % 2))" -eq 1  ]; then # Si el numero aleatorio es un numero impar
                  # Si el numero es impar ganas      
#                    echo -e "${yellowColour}[+]${endColour}${grayColour} El número que ha salido es impar,${endColour} ${greenColour}¡ganas!${endColour}"
                    reward=$(($initial_bet*2))
#                    echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour} ${yellowColour}$reward€${endColour}"
                    money=$(($money+$reward))
#                    echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour} ${yellowColour}$money${endColour}"
                    initial_bet=$backup_bet
                    jugadas_malas=""
                    max_money=$money                
                else # Si es un numero par, la apuesta se duplica
#                    echo -e "${yellowColour}[+]${endColour}${grayColour} El número ha salido par.${endColour} ${redColour}¡pierdes!${endColour}"
                    initial_bet=$(($initial_bet*2))
#                    echo -e "${yellowColour}[+]${endColour}${grayColour} Ahora mismo te quedas en${endColour} ${yellowColour}$money€${endColour}"
                    jugadas_malas+="$randon_numer "
                fi
            fi
        else # Si el dinero apostado no es mayor de cero
            echo -e "\n${yellowColour}[!]${endColour}${redColour} No tienes mas pasta cabrón!${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Has jugado un total de${blueColour} "$(($COUNTER-1))" ${endColour}${grayColour}jugadas${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Has alcanzado un total de${endColour}${yellowColour} $max_money€${endColour}"
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuación se van a representar las jugadas malas consecutivas que han salido: ${endColour}\n"
            echo -e "${yellowColour}[ ${jugadas_malas}]${endColour}"
            tput cnorm; exit 0
        fi        
    done
    tput cnorm # Recupear el cursor
}


inverseLabrouchere(){

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual ${endColour}${yellowColour}$money€${endColour}"
    echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? --> ${endColour}" && read par_impar
    initial_money=$money
    declare -a my_sequence=(1 2 3 4)

    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour}${greenColour} [${my_sequence[@]}]${endColour}"

    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
    my_sequence=(${my_sequence[@]})
    COUNTER=0 # Contador de juagadas
    
    bet_to_renew=$(($money + 50))   # Límite superior para renovar la secuencia
    bet_to_reset_lower=$(($money - 50)) # Límite inferior para renovar la secuencia
    
    jugadas_malas=() # Inicializa el array para almacenar las jugadas malas consecutivas
    my_secuence_max=() # Inicializa el array para almacenar la secuencia máxima de jugadas malas
    max_money=$money # Inicializamos max_money con el dinero inicial

    tput civis
        while true; do
        randon_numer="$(shuf -i 0-36 -n1)" 
        let money-=$bet
        let COUNTER++ # contador total de jugadas
        if [ ! "$money" -lt 0 ]; then  # Si el dinero no es menor que cero
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Invertimos${endColour} ${yellowColour}$bet€${endColour}"
            echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour} ${yellowColour}$money€${endColour}"

            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour}${blueColour} $randon_numer${endColour}"
                
            if [ "$par_impar" == "par" ]; then # si apostamos al numero par
                if [ "$(($randon_numer % 2))" -eq 0  ]; then # Si el numero aleatorio es un numero par
                    if [ "$randon_numer" -eq 0 ]; then # Si el numero aleatorio es cero pierdes
                        
                        jugadas_malas+=("$randon_numer") # Almacena la jugada mala en el array
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el${endColour} ${blueColour}0${endColour}${grayColour}, por tanto ${endColour}${redColour}¡pierdes!${endColour}"
                        unset my_sequence[0]
                        unset my_sequence[-1] 2>/dev/null
                        my_sequence=(${my_sequence[@]})

                        if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ] ; then
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                        elif [ "${#my_sequence[@]}" -eq 1 ]; then
                            bet=${my_sequence[0]}
                        else
                            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                            my_sequence=(1 2 3 4)
                            echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                        fi

                    else # EL número es par, ganamos.

                        if [ ${#jugadas_malas[@]} -gt ${#my_secuence_max[@]} ]; then
                            my_secuence_max=("${jugadas_malas[@]}") # Actualiza la secuencia máxima
                        fi
                        jugadas_malas=()     # Resetea el array de jugadas malas
                        
                        echo -e "${yellowColour}[+]${endColour}${grayColour} El número que ha salido es par,${endColour} ${greenColour}¡ganas!${endColour}"
                        my_sequence+=($bet)
                        reward=$(($bet*2))
                        let money+=($reward)
                        
                        if [ $money -gt $max_money ]; then
                            max_money=$money
                        fi
            
                        # Verifica si se ha alcanzado el límite superior o inferior para renovar la secuencia
                        if [ $money -gt $bet_to_renew ] || [ $money -lt $bet_to_reset_lower ]; then
                            echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de${endColour} ${yellowColour}$bet_to_renew€${endColour}${grayColour} o ha bajado por debajo de${endColour} ${yellowColour}$bet_to_reset_lower€${endColour}"
                            echo -e "${yellowColour}[+]${endColour}${grayColour} Se renueva la secuencia inicial a [1 2 3 4]${endColour}"
                            bet_to_renew=$(($money + 50))
                            bet_to_reset_lower=$(($money - 50))
                            my_sequence=(1 2 3 4)
                            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                            echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia ha sido restablecida a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                        fi

                        echo -e "\n Tengo${yellowColour} $money€${endColour} ${grayColour}nuestra secuencia se queda en${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

                    fi
                else # apostando a par, sale impar, pierdes...

                    jugadas_malas+=("$randon_numer")  # Almacena la jugada mala en el array
                    echo -e "${yellowColour}[+]${endColour}${grayColour} El número ha salido impar.${endColour} ${redColour}¡pierdes!${endColour}"
                    unset my_sequence[0]
                    unset my_sequence[-1] 2>/dev/null
                    my_sequence=(${my_sequence[@]})

                    echo -e "\n Tengo${yellowColour} $money€${endColour} ${grayColour}nuestra secuencia se queda en${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                    if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ] ; then
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                    elif [ "${#my_sequence[@]}" -eq 1 ]; then
                        bet=${my_sequence[0]}
                    else
                        echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                        my_sequence=(1 2 3 4)
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                    fi

                fi
                
            else # Condicional cuando apostamos a numero impar
                if [ "$(($randon_numer % 2))" -eq 1  ]; then # Si el numero aleatorio es un numero impar, ganas

                    if [ ${#jugadas_malas[@]} -gt ${#my_secuence_max[@]} ]; then
                        my_secuence_max=("${jugadas_malas[@]}") # Actualiza la secuencia máxima
                    fi
                    jugadas_malas=() # Resetea el array de jugadas malas
                    
                    echo -e "${yellowColour}[+]${endColour}${grayColour} El número que ha salido es impar,${endColour} ${greenColour}¡ganas!${endColour}"
                    my_sequence+=($bet)
                    reward=$(($bet*2))
                    let money+=($reward)

                    # Después de cada cambio en el dinero, actualiza max_money si es necesario
                    if [ $money -gt $max_money ]; then
                        max_money=$money
                    fi

                    # Verifica si se ha alcanzado el límite superior o inferior para renovar la secuencia
                    if [ $money -gt $bet_to_renew ] || [ $money -lt $bet_to_reset_lower ]; then
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de${endColour} ${yellowColour}$bet_to_renew€${endColour}${grayColour} o ha bajado por debajo de${endColour} ${yellowColour}$bet_to_reset_lower€${endColour}"
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Se renueva la secuencia inicial a [1 2 3 4]${endColour}"
                        bet_to_renew=$(($money + 50))
                        bet_to_reset_lower=$(($money - 50))
                        my_sequence=(1 2 3 4)
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                        echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia ha sido restablecida a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                    fi

                    echo -e "\n Tengo${yellowColour} $money€${endColour} ${grayColour}nuestra secuencia se queda en${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

                else # si no es impar, pierdes
                    jugadas_malas+=("$randon_numer")  # Almacena la jugada mala en el array                  
                    echo -e "${yellowColour}[+]${endColour}${grayColour} El número ha salido par.${endColour} ${redColour}¡pierdes!${endColour}"
                    unset my_sequence[0]
                    unset my_sequence[-1] 2>/dev/null
                    my_sequence=(${my_sequence[@]})
                    
                    echo -e "\n Tengo${yellowColour} $money€${endColour} ${grayColour}nuestra secuencia se queda en${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                    if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ] ; then
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                    elif [ "${#my_sequence[@]}" -eq 1 ]; then
                        bet=${my_sequence[0]}
                    else
                        echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                        my_sequence=(1 2 3 4)
                        echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a:${endColour}${greenColour} [${my_sequence[@]}]${endColour}"
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))                     
                    fi

                fi    

            fi    
            #sleep 1
        else # si nos quedamos sin dinero

            echo -e "\n${yellowColour}[!]${endColour}${redColour} No tienes mas pasta cabrón!${endColour}"
            echo -e "${yellowColour}[+]${endColour}${grayColour} Has jugado un total de${blueColour} "$(($COUNTER-1))" ${endColour}${grayColour}jugadas${endColour}"
            echo -e "${yellowColour}[+]${endColour}${grayColour} Dinero máximo alcanzado:${endColour}${yellowColour} $max_money€${endColour}"
            echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia de numeros aleatorios máxima de jugadas malas consecutivas es:${endColour}${greenColour} ${my_secuence_max[@]}${endColour}"
            tput cnorm; exit 0

        fi    

        done

    tput cnorm

}

while getopts "m:t:h" arg; do
    case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
    esac
done

if [ $money ] && [ $technique ]; then
    if [ "$technique" == "martingala" ]; then
        martingala
    elif [ "$technique" == "inverselabrouchere" ]; then
        inverseLabrouchere
    else
        echo -e "\n${redColour}La técnica introducida no existe${endColour}"
    fi
else
    helpPanel
fi
