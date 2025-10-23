#!/bin/bash
#!/bin/bash
clear
echo -e "\e[32m"
cat <<"EOF"
  
   ██████╗  ██████╗ ██╗   ██╗██╗     ██╗     ███████╗████████╗███████╗
   ██╔══██╗██╔═══██╗██║   ██║██║     ██║     ██╔════╝╚══██╔══╝██╔════╝
   ██████╔╝██║   ██║██║   ██║██║     ██║     █████╗     ██║   █████╗  
   ██╔══██╗██║   ██║██║   ██║██║     ██║     ██╔══╝     ██║   ██╔══╝  
   ██║  ██║╚██████╔╝╚██████╔╝███████╗███████╗███████╗   ██║   ███████╗
   ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚══════╝   ╚═╝   ╚══════╝
                                                                                                                                                                                                     
                                                                    
                       🎰 Roulette.sh 🎰
EOF
echo -e "\e[0m"
sleep 1

# Trap for Ctrl+C
trap handle_ctrl_c INT

# Color definitions
green_colour="\e[0;32m\033[1m"
end_colour="\033[0m\e[0m"
red_colour="\e[0;31m\033[1m"
blue_colour="\e[1;34m"
yellow_colour="\e[0;33m\033[1m"
purple_colour="\e[0;35m\033[1m"
turquoise_colour="\e[0;36m\033[1m"
gray_colour="\e[0;37m\033[1m"
grey="\e[0;37m"
bold="\e[1m"
underline="\e[4m"

# Global variables
show_help=false
initial_funds=""
betting_strategy=""
current_funds=0
starting_funds=0
max_money_martingale=0
max_money_inverse_labouchere=0
max_rounds=0
current_rounds=0
more_rounds=0
additional_rounds=0
selected_strategy=""

# Helper functions
function handle_ctrl_c() {
  echo -e "\n\n${red_colour}[!]${end_colour} Saliendo...\n"
  tput cnorm
  exit 1
}

# --------------------------------------------------------------------------------------
# Request bet choice (even/odd)
# --------------------------------------------------------------------------------------

function request_bet_and_choice() {
  while true; do
    echo -e "${blue_colour}[?]${end_colour} ${bold}¿A qué deseas apostar, par o impar?${end_colour}"
    read choice
    if [ "$choice" = "par" ] || [ "$choice" = "impar" ]; then
      break
    else
      echo -e "${red_colour}[!]${end_colour} Opción inválida. Debes elegir 'par' o 'impar'."
    fi
  done
}
# --------------------------------------------------------------------------------------
# Check maximum rounds
# --------------------------------------------------------------------------------------
#
function check_max_rounds() {
  while true; do
    echo -e "${blue_colour}[?]${end_colour} ${gray_colour}¿Cuantas rondas deseas jugar?${end_colour}"
    read max_rounds
    if [[ "$max_rounds" =~ ^[0-9]+$ ]] && [ "$max_rounds" -ge 1 ]; then
      break
    else
      echo -e "${red_colour}[!]${end_colour} Cantidad inválida. Debe ser un número entero mayor o igual a 1."
    fi
  done
}

function spin_roulette() {
  echo $((RANDOM % 37))
}

# --------------------------------------------------------------------------------------
# Verify if more rounds are needed
# --------------------------------------------------------------------------------------

function verify_more_rounds() {
  if [ "$current_rounds" -ge "$max_rounds" ]; then
    echo -e "${red_colour}[!]${end_colour} Has alcanzado el número máximo de rondas (${max_rounds})."
    while true; do
      echo -e "${blue_colour}[?]${end_colour} ${gray_colour}¿Quieres jugar mas rondas? (s/n)${end_colour}"
      read more_rounds
      if [ "$more_rounds" == "n" ] || [ "$more_rounds" == "s" ]; then
        break
      else
        echo -e "${red_colour}[!]${end_colour} Opción inválida. Debes responder 's' o 'n'."
      fi
    done
    if [ "$more_rounds" != "s" ]; then
      echo -e "${red_colour}[!]${end_colour}Saliendo de $selected_strategy con ${green_colour}$current_funds€${end_colour}"
      return
    else
      echo -e "${blue_colour}[?]${end_colour} ¿Cuantas rondas mas deseas jugar?"
      read additional_rounds
      if ! [[ "$additional_rounds" =~ ^[0-9]+$ ]] || [ "$additional_rounds" -lt 1 ]; then
        echo -e "${red_colour}[!]${end_colour} Cantidad inválida. Debe ser un número entero mayor o igual a 1."
        return
      fi
      max_rounds=$((max_rounds + additional_rounds))
    fi
  fi
}

# --------------------------------------------------------------------------------------
# Inverse Labouchere strategy
# --------------------------------------------------------------------------------------

function martingale() {
  local current_rounds=0

  # Get initial bet amount from user
  echo -e "${blue_colour}[?]${end_colour} ${bold}¿Con cuanto deseas iniciar la apuesta?${end_colour} ${underline}(Cantidad mínima: 1)${end_colour}"
  read bet_amount

  # Validate bet amount
  if ! [[ "$bet_amount" =~ ^[0-9]+$ ]] || [ "$bet_amount" -lt 1 ]; then
    echo -e "${red_colour}[!]${end_colour} Cantidad inválida. Debe ser un número entero mayor o igual a 1."
    return
  fi

  # Store initial bet for reset after wins
  local initial_bet="$bet_amount"

  # Get user's bet choice (even/odd)
  request_bet_and_choice

  # Initialize round counter
  current_rounds=0

  # Get max rounds from user
  check_max_rounds

  # Main game loop
  while [ "$current_funds" -gt 0 ] && [ "$current_rounds" -lt "$max_rounds" ]; do
    ((current_rounds++))

    # Display round information
    echo -e "${yellow_colour}Ronda${end_colour} $current_rounds - ${yellow_colour}Apostando${end_colour} $bet_amount€ ${yellow_colour}a${end_colour} $choice. ${yellow_colour}Dinero actual:${end_colour} $current_funds€"

    # Spin roulette
    result=$(spin_roulette)
    echo -e "${purple_colour}Resultado de la ruleta:${end_colour} $result"

    # Check if player won
    if { [ "$choice" == "par" ] && [ $((result % 2)) -eq 0 ] && [ "$result" -ne 0 ]; } ||
      { [ "$choice" == "impar" ] && [ $((result % 2)) -ne 0 ]; }; then

      # WIN: Add winnings and reset bet
      current_funds=$((current_funds + bet_amount))
      echo -e "${green_colour}¡Ganaste!${end_colour} Nuevo saldo: $current_funds€"
      bet_amount="$initial_bet"

    else
      # LOSS: Double bet for next round (Martingale strategy)
      current_funds=$((current_funds - bet_amount))
      echo -e "${red_colour}Perdiste.${end_colour} Nuevo saldo: ${bold}$current_funds€${end_colour}"

      bet_amount=$((bet_amount * 2))

      # Cap bet at remaining funds
      if [ "$bet_amount" -gt "$current_funds" ]; then
        bet_amount="$current_funds"
      fi
    fi

    # Ask if player wants more rounds
    verify_more_rounds

    # Check for bankruptcy
    if [ "$current_funds" -le 0 ]; then
      echo -e "\n===== ${red_colour}Te has quedado sin dinero!!😂🤣${end_colour}==="
      break
    fi
  done

  # Display final balance
  echo -e "\n${green_colour}Finalizaste con $current_funds€${end_colour}"

  # Update global max if current is higher
  if [ "$current_funds" -gt "$max_money_martingale" ]; then
    max_money_martingale=$current_funds
  fi
}

# --------------------------------------------------------------------------------------
# Inverse Labouchere strategy
# --------------------------------------------------------------------------------------

function inverse_labouchere() {
  # Display current balance
  echo -e "${blue_colour}=== Dinero Actual ===${end_colour}"
  echo -e "${green_colour}$current_funds€${end_colour}\n"

  # Get user's bet choice (even/odd)
  request_bet_and_choice

  # Initialize sequence
  declare -a sequence=(1 2 3 4)
  local current_rounds=0

  echo -e "${yellow_colour}[+] Secuencia inicial: ${sequence[@]}${end_colour}"

  # Get max rounds from user
  check_max_rounds

  # Main game loop
  while [ "$current_funds" -gt 0 ] && [ "$current_rounds" -lt "$max_rounds" ] && [ ${#sequence[@]} -gt 0 ]; do
    ((current_rounds++))

    # Calculate bet: single element or first + last
    if [ ${#sequence[@]} -eq 1 ]; then
      bet_amount=${sequence[0]}
    else
      bet_amount=$((sequence[0] + sequence[-1]))
    fi

    # Check if player has enough funds
    if [ "$bet_amount" -gt "$current_funds" ]; then
      echo -e "${red_colour}[!]${end_colour} No tienes suficiente dinero para apostar $bet_amount€"
      break
    fi

    # Display round information
    echo -e "\n${yellow_colour}Ronda${end_colour} $current_rounds"
    echo -e "${gray_colour}Secuencia actual: [${sequence[@]}]${end_colour}"
    echo -e "${yellow_colour}Apostando${end_colour} $bet_amount€ ${yellow_colour}a${end_colour} $choice. ${yellow_colour}Dinero actual:${end_colour} $current_funds€"

    # Spin roulette
    result=$(spin_roulette)
    echo -e "${purple_colour}Resultado de la ruleta:${end_colour} $result"

    # Check if player won
    if { [ "$choice" == "par" ] && [ $((result % 2)) -eq 0 ] && [ "$result" -ne 0 ]; } ||
      { [ "$choice" == "impar" ] && [ $((result % 2)) -ne 0 ]; }; then

      # WIN: Update funds and sequence
      current_funds=$((current_funds + bet_amount))

      # Update max money record
      if [ "$current_funds" -gt "$max_money_inverse_labouchere" ]; then
        max_money_inverse_labouchere="$current_funds"
      fi

      echo -e "${green_colour}¡Ganaste!${end_colour} Nuevo saldo: $current_funds€"

      # Add bet to end of sequence
      sequence+=($bet_amount)
      echo -e "${green_colour}Nueva secuencia: [${sequence[@]}]${end_colour}"

    else
      # LOSS: Update funds and remove first/last from sequence
      current_funds=$((current_funds - bet_amount))
      echo -e "${red_colour}Perdiste.${end_colour} Nuevo saldo: $current_funds€"

      # Remove first and last elements
      if [ ${#sequence[@]} -eq 1 ]; then
        unset sequence[0]
        echo -e "${red_colour}Secuencia vacía. Reiniciando...${end_colour}"
        sequence=(1 2 3 4)
      elif [ ${#sequence[@]} -eq 2 ]; then
        unset sequence[0]
        unset sequence[1]
        sequence=("${sequence[@]}")
        echo -e "${red_colour}Secuencia vacía. Reiniciando...${end_colour}"
        sequence=(1 2 3 4)
      else
        unset sequence[0]
        unset sequence[-1]
        sequence=("${sequence[@]}")
        echo -e "${red_colour}Nueva secuencia: [${sequence[@]}]${end_colour}"
      fi
    fi

    # Check for bankruptcy
    if [ "$current_funds" -le 0 ]; then
      echo -e "\n${red_colour}=== Te has quedado sin dinero! ===${end_colour}\n"
      break
    fi

    # Ask if player wants more rounds
    verify_more_rounds
  done

  # Update global max if current is higher
  if [ "$current_funds" -gt "$max_money_inverse_labouchere" ]; then
    max_money_inverse_labouchere=$current_funds
  fi

  # Display final balance
  echo -e "\n${green_colour}Finalizaste con $current_funds€${end_colour}"
}
#---------------------------------------------------------------------------------------
# Menu and stats functions
# --------------------------------------------------------------------------------------

function help_panel() {
  echo -e "\n🆒 ${yellow_colour}[+] Uso: ./roulette.sh -m [dinero] -m [tecnica o menu]${end_colour}\n"
  echo -e "\t🔄 ${purple_colour}-u${end_colour} ${gray_colour}Descargar o Actualizar los Archivos necesarios${end_colour}"
  echo -e "\t💻 ${purple_colour}-m${end_colour} ${gray_colour}Dinero con el que se desea jugar${end_colour}"
  echo -e "\t🛠️ ${purple_colour}-t${end_colour} ${gray_colour}Tecnica que deseas usar o ir al menu de apuestas${end_colour} ${purple_colour}(martingale inverseLabouchere o menu)${end_colour}"
}

function show_stats() {
  echo -e "\n${purple_colour}=== ESTADÍSTICAS ===${end_colour}"
  echo -e "Dinero inicial: ${green_colour}$starting_funds€${end_colour}"
  echo -e "Dinero actual: ${blue_colour}$current_funds€${end_colour}"
  echo -e "Ganancia maxima Martingale ${yellow_colour}$max_money_martingale€${end_colour}"
  echo -e "Ganancia maxima Inverse Labouchere ${yellow_colour}$max_money_inverse_labouchere€${end_colour}"
  echo
  local profit=$((current_funds - starting_funds))
  if [ "$profit" -gt 0 ]; then
    echo -e "[+]Ganancia: ${green_colour}+$profit€${end_colour}"
  elif [ "$profit" -lt 0 ]; then
    echo -e " [!] Pérdida: ${red_colour}$profit€${end_colour}"
  else
    echo -e "Sin ganancias ni pérdidas"
  fi
}

# --------------------------------------------------------------------------------------
# Main menu function
# --------------------------------------------------------------------------------------

function main_menu() {
  while true; do
    echo -e "\n${blue_colour}=== MENÚ PRINCIPAL ===${end_colour}"
    echo -e "${green_colour}Dinero actual: $current_funds€${end_colour}"
    echo -e "${yellow_colour}1.${end_colour} Jugar Martingale"
    echo -e "${yellow_colour}2.${end_colour} Jugar Inverse Labouchere"
    echo -e "${yellow_colour}3.${end_colour} Ver estadísticas"
    echo -e "${yellow_colour}4.${end_colour} Resetear dinero"
    echo -e "${yellow_colour}5.${end_colour} Salir"
    echo -e "${blue_colour}Selecciona una opción:${end_colour}"
    read menu_choice
    case "$menu_choice" in
    1)
      if [ "$current_funds" -gt 0 ]; then
        selected_strategy="Martingale"
        martingale
      else
        echo -e "${red_colour}[!]${end_colour} No tienes dinero para jugar"
      fi
      ;;
    2)
      if [ "$current_funds" -gt 0 ]; then
        selected_strategy="Inverse Labouchere"
        inverse_labouchere
      else
        echo -e "${red_colour}[!]${end_colour} No tienes dinero para jugar"
      fi
      ;;
    3)
      show_stats
      ;;
    4)
      current_funds="$starting_funds"
      echo -e "${blue_colour}[+]${end_colour} Dinero reseteado a ${green_colour}$current_funds€${end_colour}"
      ;;
    5)
      echo -e "${blue_colour}[+]${end_colour} Gracias por jugar. Saldo final: ${green_colour}$current_funds€${end_colour}"
      exit 0
      ;;
    *)
      echo -e "${red_colour}[!]${end_colour} Opción inválida"
      ;;
    esac
  done
}

# --------------------------------------------------------------------------------------
# Execute selected strategy
# --------------------------------------------------------------------------------------

function execute_strategy() {
  local funds="$1"
  local strategy="$2"
  if [ "$current_funds" -eq 0 ]; then
    current_funds="$funds"
    starting_funds="$funds"
  fi
  case "$strategy" in
  "menu")
    main_menu
    ;;
  "martingale")
    echo -e "${green_colour}[+]${end_colour} ${gray_colour}Ejecutando estrategia Martingale${end_colour}"
    selected_strategy="Martingale"
    martingale
    ;;
  "inverseLabouchere")
    echo -e "${green_colour}[+]${end_colour} ${gray_colour}Ejecutando estrategia Inverse Labouchere${end_colour}"
    selected_strategy="Inverse Labouchere"
    inverse_labouchere
    ;;
  *)
    echo -e "${red_colour}[!]${end_colour} Técnica '$strategy' no implementada"
    exit 1
    ;;
  esac
}

# --------------------------------------------------------------------------------------
# Parse command-line arguments
# --------------------------------------------------------------------------------------

while getopts ":m:t:h" arg; do
  case $arg in
  m)
    if [[ "$OPTARG" =~ ^[0-9]+$ ]] && [ "$OPTARG" -gt 0 ]; then
      initial_funds="$OPTARG"
      echo -e "${green_colour}[+]${end_colour} Dinero asignado: $initial_funds"
    else
      echo -e "${red_colour}[!]${end_colour} El dinero debe ser un número entero mayor que 0"
      echo -e "${red_colour}[!]${end_colour} Ejemplo: -m 1000\n"
      exit 1
    fi
    ;;
  t)
    if [[ "$OPTARG" =~ ^(martingale|inverseLabouchere|menu)$ ]]; then
      betting_strategy="$OPTARG"
      if [ "$OPTARG" = "menu" ]; then
        echo -e "\n${yellow_colour}[!]${end_colour} Has seleccionado el menú de apuestas"
      else
        echo -e "${green_colour}[+]${end_colour} Técnica seleccionada: $betting_strategy"
      fi
    else
      echo -e "${red_colour}[!]${end_colour} Técnica inválida. Usa: martingale o inverseLabouchere"
      exit 1
    fi
    ;;
  h)
    show_help=true
    ;;
  \?)
    echo -e "\n${red_colour}[!]${end_colour} Opcion invalida!"
    echo -e "\n${red_colour}[!]${end_colour} Ejemplo: -m 1000 -t 1\n"
    exit 1
    ;;
  :)
    echo -e "\n${red_colour}[!]${end_colour} Opcion $OPTARG requiere un argumento."
    exit 1
    ;;
  *)
    echo -e "${red_colour}[!]${end_colour} error inesperado"
    exit 0
    ;;
  esac
done

if $show_help; then
  help_panel
  exit 0
elif [ -n "$initial_funds" ] && [ -n "$betting_strategy" ]; then
  execute_strategy "$initial_funds" "$betting_strategy"
  exit 0
else
  help_panel
  exit 1
fi
