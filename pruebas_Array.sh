#!/bin/bash

declare -a tests=(
  "test_case_1",
  "test_case_2",
  "test_case_3")

for i in "${tests[@]}"; do
  #echo "Running $i... : ${tests[$i]} "
  echo "Finished $i... :"
done

echo ${tests[1]} # test_case_2

declare -A colores

# Asignar valores
colores[rojo]="#FF0000"
colores[verde]="#00FF00"
colores[azul]="#0000FF"

# O directamente
declare -A edades=(
  [Juan]=25
  [María]=30
  [Pedro]=28
)

# Acceder
echo ${colores[rojo]} # #FF0000
echo ${edades[María]} # 30

# Obtener todas las claves
echo ${!colores[@]} # rojo verde azul

# Obtener todos los valores
echo ${colores[@]} # #FF0000 #00FF00 #0000FF

# Iterar
for clave in "${!colores[@]}"; do
  echo "$clave = ${colores[$clave]}"
done

# Salida:
# rojo = #FF0000
# verde = #00FF00
# azul = #0000FF
