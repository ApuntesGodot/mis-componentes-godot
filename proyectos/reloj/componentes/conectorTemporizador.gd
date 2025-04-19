class_name conectorTemporizador extends Node

@export var reloj : ClockSystem

@export var nodoAvisado : Node

func _ready():
	reloj.temporizador_alerta.connect(nodoAvisado.temporizadorAlerta) 
