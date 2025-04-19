class_name ClockSystem extends Node

signal tiempo_actualizado(hora, minuto, segundo)
signal temporizador_alerta(tiempoAcabado)

const MODOS_RELOJ := ["Reloj", "Temporizador"]
@export_enum("Reloj", "Temporizador") var modo: String = "Reloj"

@export var hora_inicial: int = 0
@export var minuto_inicial: int = 0
@export var segundo_inicial: int = 0

var segundos_transcurridos: int = 0
var segundo_transcurrido: int = 1
var segundo_limite : int = 0

var timer: Timer
var emitir_alarma = true

func insertar_nueva_hora(h : int ,m : int, s : int, mode : String):
	hora_inicial = h
	minuto_inicial = m
	segundo_inicial = s
	segundos_transcurridos = 0	
	modo = mode
	encenderReloj()
	
func _ready():
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
	
	emitir_tiempo_actual()

func cambiarModo():
	match modo:
		"Reloj":
			segundo_transcurrido = 1
		"Temporizador":
			temporizador_alerta.emit()
			segundo_transcurrido = -1
			emitir_alarma = true
			establer_tiempo_limite()

func pararTiempo():
	segundo_transcurrido = 0
	
func resetearTiempoAcumulado():
	segundos_transcurridos = 0
	
func establer_tiempo_limite():
	segundo_limite = segundo_inicial + (minuto_inicial * 60) + (hora_inicial * 60 * 60)

func _on_timeout():	
	segundos_transcurridos += segundo_transcurrido
	emitir_tiempo_actual()

func emitir_tiempo_actual():
	var segundos = segundo_inicial + segundos_transcurridos
	var minutos = minuto_inicial + (segundos / 60.0)
	var horas = hora_inicial + (minutos / 60.0)
	tiempo_actualizado.emit(horas, minutos, segundos)
	if(modo == "Temporizador"):

		if(segundos_transcurridos*-1 == segundo_limite):
			# Resetea el tiempo
			#  resetearTiempoAcumulado()
			# Para el tiempo
			pararTiempo()
			
			if emitir_alarma: 
				temporizador_alerta.emit(true)
				emitir_alarma = false
		
