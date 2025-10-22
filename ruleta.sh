#!/bin/bash

function ctrl_c() {
  echo -e "\n\n[!] Saliendo...\n"
  tput cnorm
  exit 1
}

# ctrl+C
trap ctrl_c INT

# Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[1;34m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
gris="\e[0;37m"
negrita="\e[1m"
subrayado="\e[4m"

# Variables
showHelp=false
money=""
technique=""
current_money=0
initial_money=0
maxMoneyMartingala=0
maxMoneyInverseLaBroucher=0
maxRounds=0
rounds=0
more_rounds=0
additional_rounds=0
tecnicaSeleccionada=""

#funciones helpers
function solicitarApuestaYEleccion() {
  while true; do
    echo -e "${blueColour}[?]${endColour} ${negrita}¿A qué deseas apostar, par o impar?${endColour}"
    read choice

    if [ "$choice" = "par" ] || [ "$choice" = "impar" ]; then
      break # Salimos del bucle si la entrada es válida
    else
      echo -e "${redColour}[!] Opción inválida. Debes elegir 'par' o 'impar'.${endColour}"
    fi
  done
}
#     Verificar si se alcanzó el máximo de rondas
function verificarMaxRondas() {
  while true; do
    echo -e "${blueColour}[?]${endColour} ${grayColour} ¿Cuantas rondas deseas jugar? ${endColour}" && read maxRounds

    if [[ "$maxRounds" =~ ^[0-9]+$ ]] || [ "$maxRounds" -lt 0 ]; then
      break
    else
      echo -e "${redColour}[!]${endColour} ${grayColour} Cantidad inválida. Debe ser un número entero mayor o igual a 1.${endColour}"

    fi
  done
}
function girarRuleta() {
  echo $((RANDOM % 37))
}
#     Verificar si se alcanzó el máximo de rondas
function MasRondasVerificar() {
  if [ "$rounds" -ge "$maxRounds" ]; then
    echo -e "${redColour}[!]${endColour}Has alcanzado el número máximo de rondas (${maxRounds})."
    while true; do
      echo -e "${blueColour}[?]${endColour}${grayColour}¿Quieres jugar mas rondas? (s/n)${endColour}" && read more_rounds
      if [ "$more_rounds" == "n" ] || [ "$more_rounds" == "s" ]; then
        break
      else
        echo -e "${redColour}[!] Opción inválida. Debes responder 's' o 'n'.${endColour}"
      fi
    done

    if [ "$more_rounds" != "s" ]; then
      echo -e "${greenColour}Saliendo de $tecnicaSeleccionada con $current_money€${endColour}"
      return
      # Si el usuario quiere más rondas
    else
      echo -e "${blueColour}[?]${endColour}¿Cuantas rondas mas deseas jugar?" && read additional_rounds
      if ! [[ "$additional_rounds" =~ ^[0-9]+$ ]] || [ "$additional_rounds" -lt 1 ]; then
        echo -e "${redColour}[!] Cantidad inválida. Debe ser un número entero mayor o igual a 1.${endColour}"
        return
      fi
      maxRounds=$((maxRounds + additional_rounds))

    fi
  fi
}

# Help Panel

function helpPanel() {
  echo -e "\n 🆒${yellowColour}[+] Uso: ./htbmachines.sh -m <machineName>${endColour}\n"
  echo -e "\t 🔄${purpleColour}-u${endColour}${grayColour} Descargar o Actualizar los Archivos necesarios${endColour}\n"
  echo -e "\t 💻${purpleColour}-m${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"
  echo -e "\t 🛠️${purpleColour}-t${endColour}${grayColour} Tecnica que deseas usar o ir al menu de apuestas${endColour}${purpleColour} (martingala  inverseLabroucher o menu)${endColour}\n"
  echo -e "\t 📡${purpleColour}-d${endColour}${grayColour} Buscar Máquinas Por Dificultad${endColour}"
  echo -e "\t 🖥️${purpleColour}-o${endColour}${grayColour} Buscar Máquinas Por Sistema Operativo${endColour}"
  echo -e "\t 🖥️${purpleColour}-s${endColour}${grayColour} Buscar Maquina Por Skills(ej: \"Active Directory\") ${endColour}"
  echo -e "\t ❓${purpleColour}-h${endColour}${grayColour} Muestra este Panel de Ayuda${endColour}"
  echo -e "\n 🧐${greenColour}[+] Usa las opciones -d [Dificultad] y -o [Sistema operativo] para buscar por dificultad y sistema operativo ${endColour}\n"
  echo -e "\n ${redColour}[!] Dependencias requeridas: ${endColour} ${grayColour}curl, js-beautify, moreutils (para sponge), xdg-open${endColour}"
  echo -e "    Instala en Debian/Kali con: sudo apt-get install curl node-js-beautify moreutils xdg-utils\n"
}
function mainMenu() {
  while true; do
    echo -e "\n${blueColour}=== MENÚ PRINCIPAL ===${endColour}"
    echo -e "${greenColour}Dinero actual: $current_money€${endColour}"
    echo -e "${yellowColour}1.${endColour} Jugar Martingala"
    echo -e "${yellowColour}2.${endColour} Jugar Inverse Labroucher"
    echo -e "${yellowColour}3.${endColour} Ver estadísticas"
    echo -e "${yellowColour}4.${endColour} Resetear dinero"
    echo -e "${yellowColour}5.${endColour} Salir"
    echo -e "${blueColour}Selecciona una opción:${endColour} " && read menu_choice

    case "$menu_choice" in
    1)
      if [ "$current_money" -gt 0 ]; then
        tecnicaSeleccionada="Martingala"
        martingala
      else
        echo -e "${redColour}[!]${endColour} No tienes dinero para jugar"
      fi
      ;;
    2)
      if [ "$current_money" -gt 0 ]; then
        tecnicaSeleccionada="Inverse Labroucher"
        inverseLabroucher
      else
        echo -e "${redColour}[!]${endColour} No tienes dinero para jugar"
      fi
      ;;
    3)
      showStats
      ;;
    4)
      current_money="$initial_money"
      echo -e "${blueColour}[+]${endColour} Dinero reseteado a ${greenColour}$current_money€${endColour}"
      ;;
    5)
      echo -e "${blueolour}[+]${endColour} Gracias por jugar. Saldo final: ${greenColour}$current_money€${endColour}"
      exit 0
      ;;
    *)
      echo -e "${redColour}[!]${endColour} Opción inválida"
      ;;
    esac
  done
}
function showStats() {
  echo -e "\n${purpleColour}=== ESTADÍSTICAS ===${endColour}"
  echo -e "Dinero inicial: ${greenColour}$initial_money€${endColour}"
  echo -e "Dinero actual: ${blueColour}$current_money€${endColour}"
  echo -e "Ganancia maxima MartinGala ${yellowColour}$maxMoneyMartingala€${endColour}"
  echo -e "Ganancia maxima Inverse LaBroucher ${yellowColour}$maxMoneyInverseLaBroucher€${endColour}"
  echo

  local profit=$((current_money - initial_money))
  if [ "$profit" -gt 0 ]; then
    echo -e "Ganancia: ${greenColour}+$profit€${endColour}"
  elif [ "$profit" -lt 0 ]; then
    echo -e "Pérdida: ${redColour}$profit€${endColour}"
  else
    echo -e "Sin ganancias ni pérdidas"
  fi
}
function ejecutarTecnica() {
  local money="$1"
  local technique="$2"

  # Inicializar SOLO la primera vez
  if [ "$current_money" -eq 0 ]; then
    current_money="$money"
    initial_money="$money"
  fi

  case "$technique" in
  "menu")
    mainMenu # Ir directamente al menú
    ;;
  "martingala")
    echo -e "${greenColour}[+] ${endColour} ${grayColour} Ejecutando estrategia Martingala${endColour}"
    martingala
    ;;
  "inverseLabroucher")
    echo -e "${greenColour}[+] ${endColour} ${grayColour}Ejecutando estrategia Inverse Labroucher${endColour}"
    inverseLabroucher
    ;;
  *)
    echo -e "${redColour}[!] ${endColour}  ${grayColour}Técnica '$technique' no implementada${endColour}"
    exit 1
    ;;
  esac
}
function martingala() {

  local rounds=0
  #    Solicitar al usuario la cantidad inicial de la apuesta y la elección par/impar
  echo -e "${blueColour}[?]${endColour} ${negrita} ¿Con cuanto deseas iniciar la apuesta? ${endColour} ${subrayado}(Cantidad mínima: 1)${endColour}" && read bet_amount
  if ! [[ "$bet_amount" =~ ^[0-9]+$ ]] || [ "$bet_amount" -lt 1 ]; then
    echo -e "${redColour}[!]${endColour} ${grayColour} Cantidad inválida. Debe ser un número entero mayor o igual a 1.${endColour}"
    return
  fi
  local initial_bet="$bet_amount"
  #  Solicitar elección par/impar

  solicitarApuestaYEleccion
  #Variables para el bucle
  rounds=0

  #   Solicitar número máximo de rondas
  verificarMaxRondas
  # Bucle principal de la estrategia Martingala
  while [ "$current_money" -gt 0 ] && [ "$rounds" -lt $maxRounds ]; do # Limitar rondas
    ((rounds++))
    echo -e "${yellowColour}Ronda${endColour} $rounds - ${yellowColour}Apostando${endColour}  $bet_amount€ ${yellowColour}a${endColour} $choice. ${yellowColour}Dinero actual:${endColour} $current_money€"
    #    Simular el giro de la ruleta (número aleatorio entre 0 y 36)
    result=$(girarRuleta)

    echo -e "${purpleColour}Resultado de la ruleta:${endColour} $result"
    # Verificar si el jugador ganó o perdió
    if { [ "$choice" == "par" ] && [ $((result % 2)) -eq 0 ] && [ "$result" -ne 0 ]; } || { [ "$choice" == "impar" ] && [ $((result % 2)) -ne 0 ]; }; then
      current_money=$((current_money + bet_amount))
      echo -e "${greenColour}¡Ganaste!${endColour} Nuevo saldo: $current_money€"
      # Reiniciar la apuesta a la cantidad inicial
      bet_amount="$initial_bet"

    else
      #
      current_money=$((current_money - bet_amount))

      echo -e "${redColour}Perdiste.${endColour} Nuevo saldo: ${negrita} $current_money€${endColour}"
      # Duplicar la apuesta para la siguiente ronda
      bet_amount=$((bet_amount * 2))
      # Asegurarse de que la apuesta no exceda el dinero actual
      if [ "$bet_amount" -gt "$current_money" ]; then
        bet_amount="$current_money"
      fi
    fi
    #     Verificar si se alcanzó el máximo de rondas
    MasRondasVerificar
    # Verificar si el jugador se ha quedado sin dinero
    if [ "$current_money" -le 0 ]; then
      echo -e "\n ===== ${redColour}Te has quedado sin dinero!!😂🤣${endColour}==="
      break
    fi

  done
  echo -e "\n${greenColour}Finalizaste con $current_money€${endColour}"
  if [ "$current_money" -gt "$maxMoneyMartingala" ]; then
    maxMoneyMartingala=$current_money
  fi

}
function inverseLabroucher() {
  # Lógica específica de inverseLabroucher
  echo -e "${blueColour}=== Dinero Actual ===${endColour}"
  echo -e "${greenColour}$current_money€${endColour}\n"
  solicitarApuestaYEleccion

  # Secuencia inicial
  declare -a sequence=(1 2 3 4)
  local rounds=0

  echo -e "${yellowColour}[+] Secuencia inicial: ${sequence[@]}${endColour}"
  #   Solicitar número máximo de rondas
  verificarMaxRondas
  # Bucle principal
  while [ "$current_money" -gt 0 ] && [ "$rounds" -lt "$maxRounds" ] && [ ${#sequence[@]} -gt 0 ]; do
    ((rounds++))

    # Calcular apuesta (primero + último)
    if [ ${#sequence[@]} -eq 1 ]; then
      bet_amount=${sequence[0]}
    else
      bet_amount=$((sequence[0] + sequence[-1]))
    fi

    # Verificar si hay suficiente dinero
    if [ "$bet_amount" -gt "$current_money" ]; then
      echo -e "${redColour}[!] No tienes suficiente dinero para apostar $bet_amount€${endColour}"
      break
    fi

    echo -e "\n${yellowColour}Ronda${endColour} $rounds"
    echo -e "${grayColour}Secuencia actual: [${sequence[@]}]${endColour}"
    echo -e "${yellowColour}Apostando${endColour} $bet_amount€ ${yellowColour}a${endColour} $choice. ${yellowColour}Dinero actual:${endColour} $current_money€"

    # Girar ruleta
    result=$((RANDOM % 37))
    echo -e "${purpleColour}Resultado de la ruleta:${endColour} $result"

    # Verificar ganancia/pérdida
    if { [ "$choice" == "par" ] && [ $((result % 2)) -eq 0 ] && [ "$result" -ne 0 ]; } ||
      { [ "$choice" == "impar" ] && [ $((result % 2)) -ne 0 ]; }; then
      # GANASTE
      current_money=$((current_money + bet_amount))
      if [ "$current_money" -gt "$max_money" ]; then
        max_money="$current_money"
      fi

      echo -e "${greenColour}¡Ganaste!${endColour} Nuevo saldo: $current_money€"

      # Agregar la apuesta al final de la secuencia
      sequence+=($bet_amount)

      echo -e "${greenColour}Nueva secuencia: [${sequence[@]}]${endColour}"

    else
      # PERDISTE
      current_money=$((current_money - bet_amount))
      echo -e "${redColour}Perdiste.${endColour} Nuevo saldo: $current_money€"

      # Eliminar primero y último de la secuencia
      if [ ${#sequence[@]} -eq 1 ]; then
        unset sequence[0]
        echo -e "${redColour}Secuencia vacía. Reiniciando...${endColour}"
        sequence=(1 2 3 4)
      elif [ ${#sequence[@]} -eq 2 ]; then
        unset sequence[0]
        unset sequence[1]
        sequence=("${sequence[@]}") # Reindexar
        echo -e "${redColour}Secuencia vacía. Reiniciando...${endColour}"
        sequence=(1 2 3 4)
      else
        unset sequence[0]
        unset sequence[-1]
        sequence=("${sequence[@]}") # Reindexar
        echo -e "${redColour}Nueva secuencia: [${sequence[@]}]${endColour}"
      fi
    fi

    # Verificar quiebra
    if [ "$current_money" -le 0 ]; then
      echo -e "\n${redColour}=== Te has quedado sin dinero! ===${endColour}\n"
      break
    fi

    # Verificar límite de rondas
    MasRondasVerificar

  done
  if [ "$current_money" -gt "$maxMoneyInverseLaBroucher" ]; then
    maxMoneyInverseLaBroucher=$current_money
  fi
  echo -e "\n${greenColour}Finalizaste con $current_money€${endColour}"
}

while getopts ":m:t:h" arg; do
  case $arg in
  m)
    # Validar que sea número entero positivo
    if [[ "$OPTARG" =~ ^[0-9]+$ ]] && [ "$OPTARG" -gt 0 ]; then
      money="$OPTARG"
      echo -e "${greenColour}[+] Dinero asignado: $money${endColour}"
    else
      echo -e "${redColour}[!] El dinero debe ser un número entero mayor que 0${endColour}" >&2
      echo -e "[!] Ejemplo: -m 1000\n"
      exit 1
    fi
    ;;
  t)
    # Validar que sea una técnica válida
    if [[ "$OPTARG" =~ ^(martingala|inverseLabroucher|menu)$ ]]; then
      technique="$OPTARG" # Cambié "tecnique" por "technique"
      if [ "$OPTARG" = "menu" ]; then
        echo -e "\n${yellowColour}[!] Has seleccionado el menú de apuestas${endColour}"

      else
        echo -e "${greenColour}[+] Técnica seleccionada: $technique${endColour}"
      fi
    else
      echo -e "${redColour}[!] Técnica inválida. Usa: martingala o fibonacci${endColour}" >&2
      exit 1
    fi
    ;;
  h)
    showHelp=true
    ;;
  \?)
    echo -e "\n${redColour}[!]${endColour} ${grayColour}Opcion invalida!${endColour} " >&2
    echo -e "\n[!] Ejemplo:  -m 1000 -t 1\n"
    exit 1
    ;;
  :)
    echo -e "\n${redColour}[!]${endColour} ${grayColour} Opcion $OPTARG requiere un argumento.${endColour}" >&2
    exit 1
    ;;
  *)
    echo -e "${redColour}[!]${endColour} ${grayColour}error inesperado${endColour}" >&2
    exit 0
    ;;
  esac
done

if $showHelp; then
  helpPanel
  exit 0
elif [ -n "$money" ] && [ -n "$technique" ]; then
  ejecutarTecnica "$money" "$technique"

  exit 0
else
  helpPanel
  exit 1
fi
