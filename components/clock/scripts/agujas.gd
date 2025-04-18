extends CharacterBody2D
@onready var Aguja = $Aguja


@export_enum("Hora", "Minuto", "Segundo") var tipo: String

func _ready():
	Aguja.texture =load("res://components/clock/art/aguja%s.png" % tipo)

func actualizar(hora: float, minuto: float, segundo: float):
	match tipo:
		"Segundo":
			rotation = deg_to_rad(6 * segundo)
		"Minuto":
			rotation = deg_to_rad(6 * minuto)
		"Hora":
			rotation = deg_to_rad(30 * hora)	
