#Clase obsoleta.

class_name actualizarTiempo extends Node

@export var reloj : ClockSystem

@export var nodosEnlazados : Array[Node]

func _ready():
	#
	for ne in nodosEnlazados:
		if ne.has_method("actualizar"):
			reloj.tiempo_actualizado.connect(ne.actualizar)
 
