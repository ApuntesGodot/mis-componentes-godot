# Componentes

## 📦 Carpeta `componentes/`

Esta carpeta contiene scripts y escenas que pueden usarse en cualquier proyecto Godot como piezas sueltas y desacopladas.

### 🕰️ ClockSystem.gd

Componente principal que gestiona el sistema de reloj, con soporte para **modo reloj** y **modo temporizador**.


#### 🔔 Señales

- `tiempo_actualizado(hora, minuto, segundo)`  
  Se emite cada segundo con el tiempo actual. Otros nodos pueden usarla para actualizar su visualización.

- `temporizador_alerta(tiempoAcabado)`  
  Se emite al finalizar el temporizador.

---

#### ⚙️ Propiedades exportables

- `@export_enum("Reloj", "Temporizador") var modo: String`  
  Define el comportamiento del sistema. `"Reloj"` cuenta hacia adelante, `"Temporizador"` hacia atrás, se detendra cuand `segundos_transcurridos` y `segundo_limite` sean iguales.

- `@export var hora_inicial: int`  
- `@export var minuto_inicial: int`  
- `@export var segundo_inicial: int`  
  Tiempo inicial establecido desde el editor.

---
#### 📦 Variables internas

- `var segundos_transcurridos: int`  
  Cuenta el tiempo que ha pasado (positivo o negativo según el modo).

- `var segundo_transcurrido: int`  
  +1 para reloj, -1 para temporizador, 0 si está detenido.

- `var segundo_limite: int`  
  Tiempo total del temporizador, usado para saber cuándo finalizar.

- `var emitir_alarma: bool`  
  Bandera para evitar múltiples emisiones de alerta una vez terminado el temporizador.

---

#### 🔧 Métodos principales

##### `insertar_nueva_hora(h, m, s, mode)`
Establece una nueva hora y modo. Reinicia el reloj desde cero.

##### `_ready()`
Llama automáticamente a `encenderReloj()` al iniciar la escena.

##### `encenderReloj()`
Inicia o reinicia el `Timer`. Conecta el timeout y comienza a emitir el tiempo.

##### `cambiarModo()`
Ajusta el comportamiento según el valor de `modo`. Configura si debe contar hacia adelante o atrás.

##### `pararTiempo()`
Detiene el reloj estableciendo `segundo_transcurrido = 0`.

##### `emitir_tiempo_actual()`
Calcula y emite el tiempo actual en horas, minutos y segundos. También evalúa si debe emitir una alerta en modo temporizador.

#### 🧩 Uso típico

Conecta nodos externos a `tiempo_actualizado` para recibir el tiempo actual (por ejemplo, agujas o etiquetas de texto).

Conecta a `temporizador_alerta` para responder al final del temporizador (por ejemplo, mostrar una alarma o reproducir un sonido).

---

> 💡 Este componente es independiente y reutilizable. Puede integrarse en proyectos distintos conectando señales y controlándolo externamente.

### ⏱️ conectorAgujas.gd

Componente que actúa como **puente entre el `ClockSystem` y las agujas** del reloj. Escucha el tiempo actualizado y se lo transmite a cada aguja visual.

---

#### 🧩 Requiere

- Un nodo `ClockSystem` al que conectarse.
- Tres nodos tipo `CharacterBody2D` (o similares) que representen:
  - La aguja de los **segundos**
  - La aguja de los **minutos**
  - La aguja de las **horas**
- Que los nodos `Aguja*` tengan un método `actualizar(h, m, s)` que se conecte a la señal `tiempo_actualizado` del reloj.

---

#### ⚙️ Propiedades exportables

- `@export var reloj: ClockSystem`  
  Referencia al reloj que emite el tiempo.

- `@export var AgujaSegundo: CharacterBody2D`  
  Nodo que representa la aguja de los segundos.

- `@export var AgujaMinuto: CharacterBody2D`  
  Nodo que representa la aguja de los minutos.

- `@export var AgujaHora: CharacterBody2D`  
  Nodo que representa la aguja de las horas.

---

#### 🔧 Función principal

##### `_ready()`
Conecta la señal `tiempo_actualizado` del reloj a cada una de las agujas para que actualicen su rotación o visualización en tiempo real.

---

#### 🧠 Uso recomendado

Este script sirve como **conector visual**. Deja la lógica del tiempo en el reloj (`ClockSystem`) y separa la presentación en las agujas, favoreciendo una arquitectura desacoplada.

Ideal si deseas **reutilizar el sistema de tiempo** con diferentes estilos de reloj visual.

---

> 💡 Puedes usar este script con cualquier nodo que responda al método `actualizar(h, m, s)`, no tiene por qué ser una aguja clásica.

## ⏰ conectorTemporizador.gd

Este componente sirve como **puente entre el sistema `ClockSystem` y cualquier nodo que deba ser notificado cuando el temporizador finaliza**.

---

### 🧩 Requiere

- Un nodo `ClockSystem` con la señal `temporizador_alerta`.
- Un nodo externo (`nodoAvisado`) que implemente el método `temporizadorAlerta()`.

---

### ⚙️ Propiedades exportables

- `@export var reloj: ClockSystem`  
  Referencia al reloj que actúa como temporizador.

- `@export var nodoAvisado: Node`  
  Nodo que recibirá la notificación cuando el temporizador llegue a su fin.  

# Ejemplo

## 🧪 Carpeta `ejemplo/`

Contiene una escena de ejemplo completamente funcional que **demuestra el uso de todos los componentes del sistema de reloj**:

---

### 🔧 ¿Qué incluye?

- ⏰ Un nodo `ClockSystem` configurado en distintos modos.
- 🕹️ Interfaces de entrada (`LineEdit`, `OptionButton`) para modificar hora y modo en tiempo real.
- ⏱️ Visualización mediante agujas (segundos, minutos, horas).
- 🔔 Sistema de alarma que reacciona al final del temporizador.
- 📋 Cronómetro funcional que guarda marcas de tiempo.
- 🧩 Conectores desacoplados entre cada componente, replicando un sistema modular.

---

### 🧠 Propósito

- ✅ Comprobar el correcto funcionamiento de cada pieza por separado.
- ✅ Probar combinaciones y flujos (cronómetro, temporizador, reloj).
- ✅ Servir como plantilla para integrarlo en otros proyectos.

---

> 💡 Si descargás el repositorio, podés abrir directamente esta escena para probarlo todo en acción.

## 🎭 Carpeta `escenas/`

Contiene escenas visuales y scripts del sistema. Estas escenas representan los elementos gráficos y se actualizan en función de los datos emitidos por el `ClockSystem`.

---

### 🎯 Escena: `Aguja`

**Script:** `agujas.gd`  
**Tipo:** `CharacterBody2D`

Representa una aguja visual del reloj (horas, minutos o segundos) y reproduce un sonido tipo "tick-tack" al moverse cada segundo (solo en el caso del segundero).

---

### ⚙️ Propiedades exportables

- `@export_enum("Hora", "Minuto", "Segundo") var tipo`  
  Define el comportamiento visual según el tipo de aguja:
  - `"Hora"` → Rota 30° por hora.
  - `"Minuto"` → Rota 6° por minuto.
  - `"Segundo"` → Rota 6° por segundo y alterna sonidos tick/tack.

- `@export var tick_sonido : AudioStream`  
  Sonido a reproducir cada segundo (alternado con el tack).

- `@export var tack_sonido : AudioStream`  
  Sonido alternativo al tick.

---

### 🔁 Comportamiento

- En el método `_ready()`:
  - Carga dinámicamente la textura de la aguja según su tipo (reutiliza imágenes como `agujaHora.png`, `agujaMinuto.png`, etc.).

- En el método `actualizar(hora, minuto, segundo)`:
  - Calcula el ángulo de rotación correspondiente.
  - En el caso del segundero, alterna entre `tick` y `tack` en cada segundo, evitando repeticiones en el mismo segundo.

---

### 🧠 Requisitos

Debe estar conectado a la señal `tiempo_actualizado(h, m, s)` del `ClockSystem`, por ejemplo usando `conectorAgujas.gd`.

---

> 💡 Esta escena puede reutilizarse en cualquier interfaz visual de reloj sin necesidad de modificar su lógica interna.

## 🎨 Carpeta `recursos/`

Aquí se almacenan los **archivos visuales y sonoros** que complementan los componentes del sistema de reloj:

- 🖼️ Imágenes: agujas del reloj, carátula sin manecillas, etc.
- 🔊 Audios: sonidos "tick" y "tack", alarma.

> 💡 Todos los recursos tienen licencia libre o están correctamente acreditados. Consultá el archivo `README.md` de la carpeta para más detalles.
