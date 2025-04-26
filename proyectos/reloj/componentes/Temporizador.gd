class_name Temporizador extends Node

@export var reloj : ClockSystem
@export var DuracionTemporizador: int  = 0 


@export var nodosSucritosEmisores : Array[Node]

signal tiempoAcabado
@export var nodosSucritosReceptores : Array[Node]


var alarma_encendida


func encenderAlarma(dt : int = DuracionTemporizador):
	alarma_encendida = true
	DuracionTemporizador = dt + reloj.segundos_transcurridos
	
func actualizar(SegundosAcumulados : int):
	#print(alarma_encendida)
	if !alarma_encendida: return
	print(str(DuracionTemporizador)+" > "+str(SegundosAcumulados))
	if DuracionTemporizador-SegundosAcumulados <= 0:
		alarma_encendida = false

	tiempoAcabado.emit(alarma_encendida,DuracionTemporizador-SegundosAcumulados)

func _ready():
	encenderAlarma()
	_suscribirNodos(false)
		
func _suscribirNodos(lock = true):
	if lock : 
		print("\n🚫 Función bloqueada: _suscribirNodos() \nNingun nodo ha sido suscrito al signal")
		return
	
	for ns in nodosSucritosEmisores:
			ns.configurarAlarma.connect(encenderAlarma)
				
	for ns in nodosSucritosReceptores:
		if ns.has_method("recibirAlarma"):
			tiempoAcabado.connect(ns.recibirAlarma)
