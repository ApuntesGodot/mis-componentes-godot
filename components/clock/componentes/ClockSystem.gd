class_name ClockSystem extends Node

signal tiempo_actualizado(hora, minuto, segundo)

@export var hora_inicial: int = 0
@export var minuto_inicial: int = 0
@export var segundo_inicial: int = 0

var segundos_transcurridos: int = 0

func insertar_nueva_hora(h : int ,m : int, s : int):
	hora_inicial = h
	minuto_inicial = m
	segundo_inicial = s
	segundos_transcurridos = 0	

func _ready():

	var timer = Timer.new()
	timer.wait_time = 1.00
	timer.one_shot = false 
	timer.timeout.connect(_on_timeout)
	add_child(timer)
	timer.start()
	
	emitir_tiempo_actual()
	
func _on_timeout():
	
	segundos_transcurridos += 1
	emitir_tiempo_actual()

func emitir_tiempo_actual():
	var segundos = segundo_inicial + segundos_transcurridos
	var minutos = minuto_inicial + (segundos / 60.0)
	var horas = hora_inicial + (minutos / 60.0)
	tiempo_actualizado.emit(horas, minutos, segundos)
