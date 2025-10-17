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
#funciones

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
        martingala
      else
        echo -e "${redColour}[!] No tienes dinero para jugar${endColour}"
      fi
      ;;
    2)
      if [ "$current_money" -gt 0 ]; then
        inverseLabroucher
      else
        echo -e "${redColour}[!] No tienes dinero para jugar${endColour}"
      fi
      ;;
    3)
      showStats
      ;;
    4)
      current_money="$initial_money"
      echo -e "${greenColour}[+] Dinero reseteado a $current_money€${endColour}"
      ;;
    5)
      echo -e "${greenColour}[+] Gracias por jugar. Saldo final: $current_money€${endColour}"
      exit 0
      ;;
    *)
      echo -e "${redColour}[!] Opción inválida${endColour}"
      ;;
    esac
  done
}
function showStats() {
  echo -e "\n${purpleColour}=== ESTADÍSTICAS ===${endColour}"
  echo -e "Dinero inicial: ${greenColour}$initial_money€${endColour}"
  echo -e "Dinero actual: ${blueColour}$current_money€${endColour}"

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
    echo -e "${greenColour}[+] Ejecutando estrategia Martingala${endColour}"
    martingala
    ;;
  "inverseLabroucher")
    echo -e "${greenColour}[+] Ejecutando estrategia Inverse Labroucher${endColour}"
    inverseLabroucher
    ;;
  *)
    echo -e "${redColour}[!] Técnica '$technique' no implementada${endColour}"
    exit 1
    ;;
  esac
}
function martingala() {
  bet_amount=1
  choice=""
  echo -e "${blueColour}[?]${endColour} ${negrita}Con cuando desas iniciar la apuesta (Cantidad mínima: 1)${endColour}" && read bet_amount
  if ! [[ "$bet_amount" =~ ^[0-9]+$ ]] || [ "$bet_amount" -lt 1 ]; then
    echo -e "${redColour}[!] Cantidad inválida. Debe ser un número entero mayor o igual a 1.${endColour}"
    return
  fi
  echo -e "${blueColour}[?]${endColour} ${negrita}A que deseas apostar par o impar?${endColour}" && read choice
  if [ "$choice" != "par" ] && [ "$choice" != "impar" ]; then
    echo -e "${redColour}[!] Opción inválida. Debes elegir 'par' o 'impar'.${endColour}"
    return
  fi

  local rounds=0
  echo -e "${blueColour}[?]${endColour} ${negrita} Cuantas rondas desdeas jugar: ${endColour}" && read maxRounds
  if ! [[ "$rounds" =~ ^[0-9]+$ ]] || [ "$rounds" -lt 0 ]; then
    echo -e "${redColour}[!] Cantidad inválida. Debe ser un número entero mayor o igual a 1.${endColour}"
    return
  fi
  while [ "$current_money" -gt 0 ] && [ "$rounds" -lt $maxRounds ]; do # Limitar rondas
    ((rounds++))
    echo -e "${yellowColour}Ronda $rounds - Apostando $bet_amount€ a $choice. Dinero actual: $current_money€${endColour}"

    result=$((RANDOM % 37))
    echo -e "${purpleColour}Resultado de la ruleta: $result${endColour}"

    if { [ "$choice" == "par" ] && [ $((result % 2)) -eq 0 ] && [ "$result" -ne 0 ]; } || { [ "$choice" == "impar" ] && [ $((result % 2)) -ne 0 ]; }; then
      current_money=$((current_money + bet_amount))
      echo -e "${greenColour}¡Ganaste! Nuevo saldo: $current_money€${endColour}"
      bet_amount=1
    else
      current_money=$((current_money - bet_amount))
      echo -e "${redColour}Perdiste. Nuevo saldo: $current_money€${endColour}"
      bet_amount=$((bet_amount * 2))
      if [ "$bet_amount" -gt "$current_money" ]; then
        bet_amount="$current_money"
      fi
    fi
    if [ "$rounds" -ge "$maxRounds" ]; then
      echo -e "${blueColour}Has alcanzado el número máximo de rondas (${maxRounds}).${endColour}"
      echo -e "${greenColour}¿Quieres jugar mas rondas? (s/n)${endColour}" && read more_rounds

      if [ "$more_rounds" != "s" ]; then
        echo -e "${greenColour}Saliendo de Martingalaaa con $current_money€${endColour}"
        return

      else
        echo -e "${blueColour}¿Cuantas rondas mas deseas jugar? ${endColour}" && read additional_rounds
        if ! [[ "$additional_rounds" =~ ^[0-9]+$ ]] || [ "$additional_rounds" -lt 1 ]; then
          echo -e "${redColour}[!] Cantidad inválida. Debe ser un número entero mayor o igual a 1.${endColour}"
          return
        fi
        maxRounds=$((maxRounds + additional_rounds))

      fi
    fi
    if [ "$current_money" -le 0 ]; then
      echo -e "${redColour}Te has quedado sin dinero.${endColour}"
      break
    fi

    echo -e "${blueColour}¿Deseas continuar con Martingala? (s/n)${endColour}" && read continue_choice
    if [ "$continue_choice" != "s" ]; then
      echo -e "${greenColour}Saliendo de Martingala con $current_money€${endColour}"
      return
    fi
  done

  # NO hacer exit aquí, volver al menú
}
function inverseLabroucher() {
  # Lógica específica de inverseLabroucher
  sequence=(1 1)
  # Tu implementación aquí
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
