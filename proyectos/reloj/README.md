# Componentes

## 📦 Carpeta `componentes/`

Esta carpeta contiene scripts y escenas que pueden usarse en cualquier proyecto Godot como piezas sueltas y desacopladas.

### ClockSystem

Componente modular de Godot que gestiona el paso del tiempo en dos modos: **Reloj** y **Temporizador**.

---

#### Señales

- `tiempo_actualizado(hora, minuto, segundo, segundosAcumulados)`  
  Se emite en cada tic del reloj.

- `temporizador_alerta(tiempoAcabado)`  
  Se emite cuando el temporizador llega a cero.

---

#### Propiedades Exportables

- `@export_enum("Reloj", "Temporizador") var modo: String`  
  Modo de funcionamiento.

- `@export var hora_inicial: int`  
  Horas iniciales.

- `@export var minuto_inicial: int`  
  Minutos iniciales.

- `@export var segundo_inicial: int`  
  Segundos iniciales.

- `@export var nodosSuscritos: Array[Node]`  
  Lista de nodos que recibirán actualizaciones de tiempo.

---

#### Variables internas

- `segundos_transcurridos: int`  
  Segundos avanzados o retrocedidos.

- `segundo_transcurrido: int`  
  +1 o -1 según el modo.

- `segundo_limite: int`  
  Límite para el temporizador.

- `timer: Timer`  
  Temporizador interno.

- `emitir_alarma: bool`  
  Control de alerta de temporizador.

---

#### Métodos públicos

- `insertar_nueva_hora(h, m, s, mode)`  
  Establece nueva hora y modo.

- `modificar_tiempo(h, m, s)`  
  Modifica el tiempo actual.

- `cambiarVelocidad(v)`  
  Cambia la velocidad del `Timer`.

- `detenerConteoSegundos()`  
  Detiene el reloj.

- `resetearTiempoAcumulado()`  
  Reinicia el contador.

---

#### Flujo de funcionamiento

1. Se suscriben automáticamente los nodos en `nodosSuscritos`.
2. Se inicia el `Timer` en el modo seleccionado.
3. Cada segundo se actualiza y se emiten señales.
4. En modo temporizador, al llegar a cero, se detiene y se lanza la alerta.

---

#### Uso recomendado

- Conectar nodos externos que tengan el método `actualizar(segundosAcumulados)`.
- Alternar entre modos en ejecución.
- Modificar tiempo de forma dinámica.

---

#### Notas

- No pensado para alta precisión en frames.
- Puedes usar la suscripción automática o manualmente.
- Solo nodos con `actualizar()` serán suscritos automáticamente.

---


### ⏰ conectorTemporizador.gd

Este componente sirve como **puente entre el sistema `ClockSystem` y cualquier nodo que deba ser notificado cuando el temporizador finaliza**.

---

#### 🧩 Requiere

- Un nodo `ClockSystem` con la señal `temporizador_alerta`.
- Un nodo externo (`nodoAvisado`) que implemente el método `temporizadorAlerta()`.

---

#### ⚙️ Propiedades exportables

- `@export var reloj: ClockSystem`  
  Referencia al reloj que actúa como temporizador.

- `@export var nodoAvisado: Node`  
  Nodo que recibirá la notificación cuando el temporizador llegue a su fin.  

---

### Temporizador

Componente de Godot que permite controlar alarmas independientes usando un `ClockSystem` como base de tiempo.

---

#### Señales

- `tiempoAcabado(alarma_encendida, tiempo_restante)`  
  Se emite cuando el tiempo del temporizador llega a cero o está activo.

---

#### Propiedades Exportables

- `@export var reloj: ClockSystem`  
  Nodo que proporciona el conteo de segundos.

- `@export var DuracionTemporizador: int`  
  Duración en segundos del temporizador.

- `@export var nodosSucritosEmisores: Array[Node]`  
  Nodos que pueden solicitar el encendido de la alarma mediante una señal `configurarAlarma`.

- `@export var nodosSucritosReceptores: Array[Node]`  
  Nodos que reaccionan cuando el temporizador finaliza.

---

#### Variables internas

- `alarma_encendida: bool`  
  Indica si el temporizador está activo.

---

#### Métodos públicos

- `encenderAlarma(dt: int = DuracionTemporizador)`  
  Inicia el temporizador a partir de la duración especificada.

- `actualizar(SegundosAcumulados: int)`  
  Actualiza el estado del temporizador en cada tic del reloj.

---

#### Flujo de funcionamiento

1. Al iniciar, el temporizador se activa automáticamente (`_ready()`).
2. Cada actualización de tiempo (`actualizar`) compara el tiempo acumulado con la duración inicial.
3. Al llegar a cero, emite la señal `tiempoAcabado` para notificar a los nodos receptores.

---

#### Uso recomendado

- Conectar `ClockSystem.tiempo_actualizado` al método `actualizar`.
- Usar `configurarAlarma` en nodos emisores para reiniciar o modificar el temporizador.
- Conectar la señal `tiempoAcabado` a cualquier nodo que necesite reaccionar al finalizar el temporizador.

---

#### Notas

- Este componente es autónomo y puede reutilizarse en múltiples instancias dentro de una escena.
- Ideal para sistemas de alarmas, cooldowns o eventos cronometrados en juegos y aplicaciones.

---

### TemporizadorStandAlone

Componente de Godot que implementa un **temporizador autónomo** utilizando su propio `Timer` interno, sin depender de otros sistemas de tiempo.

---

#### Señales

- `tiempoAcabado(alarma_encendida, tiempo_restante)`  
  Se emite en cada actualización indicando si el temporizador sigue activo y cuánto tiempo queda.

---

#### Propiedades Exportables

- `@export var DuracionTemporizador: int`  
  Duración inicial en segundos del temporizador.

- `@export var nodosSucritosEmisores: Array[Node]`  
  Nodos que pueden activar o configurar el temporizador mediante señales.

- `@export var nodosSucritosReceptores: Array[Node]`  
  Nodos que serán notificados al finalizar el temporizador.

---

#### Variables internas

- `timer: Timer`  
  Nodo `Timer` interno para la cuenta regresiva.

- `segundos: int`  
  Contador de segundos transcurridos.

- `alarma_encendida: bool`  
  Indica si el temporizador está activo.

---

#### Métodos públicos

- `encenderAlarma(dt: int = DuracionTemporizador)`  
  Inicia el temporizador a partir del valor indicado.

- `inciar_temporizador()`  
  Crea y arranca el `Timer` si no existe o lo reinicia si ya está creado.

- `actualizar()`  
  Incrementa el contador y emite el estado de la alarma.

---

#### Flujo de funcionamiento

1. Al iniciar (`_ready()`), suscribe los nodos y enciende el temporizador.
2. El `Timer` interno ejecuta `actualizar()` cada segundo.
3. Se evalúa si el tiempo ha terminado y se emite `tiempoAcabado`.
4. Puede ser reiniciado en cualquier momento llamando a `encenderAlarma()`.

---

#### Uso recomendado

- Usar en proyectos donde se necesiten **múltiples temporizadores independientes**.
- No requiere un `ClockSystem`, funciona de manera completamente autónoma.
- Ideal para alarmas, cooldowns, control de tiempo de eventos, etc.

---

> 💡 Esta clase es especialmente útil cuando quieres temporizadores rápidos sin montar un sistema de reloj global.

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

> 💡 Si descargas el repositorio, podés abrir directamente esta escena para probarlo todo en acción.

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
