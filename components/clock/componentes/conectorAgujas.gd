class_name conectorAgujas extends Node

@export var reloj : ClockSystem

@export var AgujaSegundo : CharacterBody2D
@export var AgujaMinuto : CharacterBody2D
@export var AgujaHora : CharacterBody2D


func _ready():
	reloj.tiempo_actualizado.connect(AgujaSegundo.actualizar)
	reloj.tiempo_actualizado.connect(AgujaMinuto.actualizar)
	reloj.tiempo_actualizado.connect(AgujaHora.actualizar)
	
