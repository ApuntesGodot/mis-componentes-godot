class_name TemporizadorStandAlone extends Node

signal tiempoAcabado

var timer
var segundos = 0

@export var DuracionTemporizador: int  = 0 
@export var nodosSucritosEmisores : Array[Node]
@export var nodosSucritosReceptores : Array[Node]


var alarma_encendida
func _ready():
	_suscribirNodos(false)
	encenderAlarma(DuracionTemporizador)
		
func inciar_temporizador():
	
	if timer:
		timer.stop()
	else:
		timer = Timer.new()
		timer.wait_time = 1.00
		timer.one_shot = false 
		timer.timeout.connect(actualizar)
		add_child(timer) 
	segundos = 0	
	timer.start()

func encenderAlarma(dt : int = DuracionTemporizador):
	alarma_encendida = true
	DuracionTemporizador = dt
	print("DUración")
	inciar_temporizador()	
	actualizar()

func actualizar():#SegundosAcumulados : int#
	print("SEGUNDO :"+str(DuracionTemporizador)+" | "+str(segundos))
	if !alarma_encendida: return
	print("ENGEGAT!")
	if  DuracionTemporizador <= segundos:
		alarma_encendida = false
	else:
		segundos = segundos + 1

	tiempoAcabado.emit(alarma_encendida,DuracionTemporizador-segundos)


func _suscribirNodos(lock = true):
	if lock : 
		print("\n🚫 Función bloqueada: _suscribirNodos() \nNingun nodo ha sido suscrito al signal")
		return
	
	for ns in nodosSucritosEmisores:
			ns.configurarAlarma.connect(encenderAlarma)
				##
	for ns in nodosSucritosReceptores:
		if ns.has_method("recibirAlarma"):
			tiempoAcabado.connect(ns.recibirAlarma)
