<div align="center">

![Bash](https://img.shields.io/badge/bash-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)

</div>

¡Bienvenido al **Roulette Simulator**, un emocionante script en Bash que te permite simular apuestas en la ruleta con dos estrategias clásicas: **Martingala** e **Inverse Labouchère**! 🎲 Este proyecto es perfecto para quienes quieren experimentar con estas técnicas de apuestas, entender su dinámica y divertirse sin arriesgar dinero real. 🚀

---

## ⭐ ¿Qué es este proyecto?

Este script simula un juego de **ruleta europea** (37 números, 0-36) donde puedes apostar a **par** o **impar** utilizando dos estrategias de apuestas famosas. 🧠 El programa te permite:

- 💰 Iniciar con un monto de dinero personalizado
- 🎮 Elegir entre las estrategias Martingala, Inverse Labouchère o un menú interactivo
- 📊 Ver estadísticas detalladas de tus ganancias o pérdidas
- 🔄 Reiniciar tu saldo o salir cuando quieras
- 🎨 Interfaz colorida para una experiencia visual agradable

¡Todo esto desde la terminal, con un código limpio y organizado! 😎

---
<img width="969" height="576" alt="image" src="https://github.com/user-attachments/assets/0b2e6cbd-b1bc-4886-a66c-b7c5558cb126" />

## 🎲 Estrategias de Apuestas

### 1️⃣ Martingala 💸

La estrategia **Martingala** es una técnica clásica y arriesgada. 📈 Consiste en:

- ✅ Apostar una cantidad inicial
- ❌ Si pierdes, **duplicas** la apuesta en la siguiente ronda
- ✅ Si ganas, vuelves a la apuesta inicial

**Ejemplo:**
```
Ronda 1: Apuesta 5€ → Pierdes
Ronda 2: Apuesta 10€ → Pierdes
Ronda 3: Apuesta 20€ → Ganas → Recuperas pérdidas
Ronda 4: Apuesta 5€ → Vuelves al inicio
```

> ⚠️ **Advertencia:** Ideal para recuperar pérdidas rápidamente, pero puede ser intenso si tienes una racha perdedora larga. 😅

---

### 2️⃣ Inverse Labouchère 🔢

La estrategia **Inverse Labouchère** es más compleja y estratégica. 🧮 Funciona así:

1. 📝 Usas una secuencia de números (por defecto: `[1, 2, 3, 4]`)
2. 🎯 Apuestas la **suma del primer y último** número de la secuencia
3. ✅ Si **ganas**, añades la apuesta al **final** de la secuencia
4. ❌ Si **pierdes**, eliminas el **primer y último** número
5. 🔄 Si la secuencia se vacía, se reinicia

**Ejemplo:**
```
Secuencia: [1, 2, 3, 4]
Apuesta: 1 + 4 = 5€ → Ganas
Nueva secuencia: [1, 2, 3, 4, 5]

Apuesta: 1 + 5 = 6€ → Pierdes
Nueva secuencia: [2, 3, 4] (eliminamos 1 y 5)
```

> 💡 **Ventaja:** Perfecta para quienes quieren un enfoque más estructurado y aprovechar rachas ganadoras.

---

## 🚀 ¿Cómo usar el simulador?

### 📋 Requisitos

Solo necesitas:
- 🐧 Un sistema basado en Linux (como Debian, Kali, Ubuntu, etc.)
- 🔧 Bash (ya incluido en la mayoría de sistemas Linux)

---

### ⚙️ Instalación

1. **Clona este repositorio** en tu máquina:
   ```bash
   git clone https://github.com/TU_USUARIO/roulette-simulator.git
   cd roulette-simulator
   ```

2. **Dale permisos de ejecución** al script:
   ```bash
   chmod +x ruleta.sh
   ```

---

### 🎮 Ejecución

Ejecuta el script con los siguientes comandos:

**Jugar con una estrategia específica:**
```bash
./ruleta.sh -m 1000 -t martingala
# o
./ruleta.sh -m 1000 -t inverseLabroucher
```
> Donde `-m` es el dinero inicial y `-t` es la técnica.

**Acceder al menú interactivo:**
```bash
./ruleta.sh -m 1000 -t menu
```

**Ver la ayuda:**
```bash
./ruleta.sh -h
```

---

### 📜 Opciones del menú

En el modo interactivo (`-t menu`), puedes:

1. ✅ Jugar con la estrategia **Martingala**
2. ✅ Jugar con la estrategia **Inverse Labouchère**
3. 📊 Ver **estadísticas** de tus juegos
4. 🔄 **Resetear** tu saldo
5. 🚪 **Salir** del juego

---

## 🎨 Características destacadas

- 🌈 **Interfaz colorida** - Mensajes con colores para una experiencia visual clara
- ✅ **Validación robusta** - Entradas validadas para evitar errores
- 📈 **Estadísticas detalladas** - Seguimiento de tu dinero inicial, actual, y máximas ganancias por estrategia
- 🔄 **Flexibilidad** - Puedes elegir cuántas rondas jugar y añadir más si quieres
- 👨‍💻 **Código organizado** - Estructura profesional con funciones claras y comentarios

---

## ⚠️ Notas importantes

> 😇 Este es un simulador; **no uses estas estrategias con dinero real** sin entender los riesgos.

> 🎰 La ruleta es un **juego de azar**, y ninguna estrategia garantiza ganancias.

> 

---

## 🤝 Contribuciones

¡Este proyecto está abierto a mejoras! Si tienes ideas, correcciones o nuevas funcionalidades:

1. 🍴 Haz un **fork** del repositorio
2. 🌿 Crea una rama para tus cambios: `git checkout -b mi-nueva-funcionalidad`
3. 💾 Haz **commit** de tus cambios: `git commit -m "Añadí algo genial"`
4. 📤 Sube tu rama: `git push origin mi-nueva-funcionalidad`
5. 🚀 Abre un **Pull Request**

---

## 🌟 ¡Diviértete apostando virtualmente!

Esperamos que disfrutes este simulador tanto como nosotros disfrutamos creándolo. 🎉 ¡Prueba las estrategias, experimenta, y descubre si la suerte está de tu lado! 🍀 

Si tienes preguntas o sugerencias, no dudes en abrir un **issue** en el repositorio.

**¡A girar la ruleta!** 🎡
