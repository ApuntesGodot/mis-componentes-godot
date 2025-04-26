class_name ClockSystem
extends Node

# 🛎️ Señales
signal tiempo_actualizado(hora, minuto, segundo, segundosAcumulados)
signal temporizador_alerta(tiempoAcabado)

# ⚙️ Configuración exportable
const MODOS_RELOJ := ["Reloj", "Temporizador"]
@export_enum("Reloj", "Temporizador") var modo: String = "Reloj"

@export var hora_inicial: int = 0
@export var minuto_inicial: int = 0
@export var segundo_inicial: int = 0

@export var _sep_configuracion := "--- Nodos Suscritos ---"
@export var nodosSuscritos: Array[Node]

# 🧩 Variables internas
var segundos_transcurridos: int = 0
var segundo_transcurrido: int = 1
var segundo_limite: int = 0

var timer: Timer
var emitir_alarma = true

# 🚀 Métodos públicos

func insertar_nueva_hora(h: int, m: int, s: int, mode: String):
	print("🕒 Insertando nueva hora")
	hora_inicial = h
	minuto_inicial = m
	segundo_inicial = s
	segundos_transcurridos = 0
	modo = mode
	encenderReloj()

func modificar_tiempo(h: int, m: int, s: int):
	segundos_transcurridos += h * 3600 + m * 60 + s
	if modo == "Temporizador":
		if (segundos_transcurridos * -1) >= (segundo_limite - 1):
			segundos_transcurridos = (segundo_limite * -1) + 1
	cambiarModo()

func cambiarVelocidad(v):
	timer.wait_time = v

func detenerConteoSegundos():
	segundo_transcurrido = 0

func resetearTiempoAcumulado():
	segundos_transcurridos = 0

# 🔥 Funciones principales

func _ready():
	_suscribirNodos(false)
	encenderReloj()

func encenderReloj():
	cambiarModo()

	if timer:
		timer.stop()
	else:
		timer = Timer.new()
		timer.wait_time = 1.00
		timer.one_shot = false
		timer.timeout.connect(_on_timeout)
		add_child(timer)

	timer.start()
	print("⏱️ Tiempo iniciado en modo " + modo)
	emitir_tiempo_actual()

func cambiarModo():
	match modo:
		"Reloj":
			segundo_transcurrido = 1
		"Temporizador":
			configurar_alarma(true)
			segundo_transcurrido = -1
			emitir_alarma = true
			establecer_tiempo_limite()

func establecer_tiempo_limite():
	segundo_limite = segundo_inicial + (minuto_inicial * 60) + (hora_inicial * 3600)

func _on_timeout():
	segundos_transcurridos += segundo_transcurrido
	emitir_tiempo_actual()

func emitir_tiempo_actual():
	var segundos = segundo_inicial + segundos_transcurridos
	var minutos = minuto_inicial + (segundos / 60.0)
	var horas = hora_inicial + (minutos / 60.0)

	tiempo_actualizado.emit(horas * 3600)

	if modo == "Temporizador":
		if (segundos_transcurridos * -1) >= segundo_limite:
			detenerConteoSegundos()
			if emitir_alarma:
				if (segundos_transcurridos * -1) >= segundo_limite:
					segundos_transcurridos = segundo_limite * -1
					configurar_alarma(false)
				elif (segundos_transcurridos * -1) == segundo_limite:
					configurar_alarma(false)

func configurar_alarma(status):
	temporizador_alerta.emit(!status)
	emitir_alarma = status

# 🛠️ Funciones internas

func _suscribirNodos(lock = true):
	if lock:
		print("\n🚫 Función bloqueada: _suscribirNodos() \nNingún nodo ha sido suscrito al signal")
		return

	if nodosSuscritos:
		for ns in nodosSuscritos:
			if ns.has_method("actualizar"):
				print(ns.name + " tiene método actualizar")
				tiempo_actualizado.connect(ns.actualizar)
