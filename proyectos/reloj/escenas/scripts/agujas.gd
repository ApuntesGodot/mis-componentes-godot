extends CharacterBody2D
@onready var Aguja = $Aguja
@export var tick_sonido : AudioStream
@export var tack_sonido : AudioStream
@onready var reproductor = $Reproductor
var alternador_tick = true
var ultimo_segundo

@export_enum("Hora", "Minuto", "Segundo") var tipo: String

func _ready():
	Aguja.texture =load("res://proyectos/reloj/recursos/arte/aguja%s.png" % tipo)

func actualizar(segundo : float):
	match tipo:
		"Segundo":
			if ultimo_segundo!=segundo:
				
				if alternador_tick:
					reproductor.stream = tick_sonido
				else:
					reproductor.stream = tack_sonido
			
				reproductor.play()
				
				alternador_tick = !alternador_tick
				rotation = deg_to_rad(6 * segundo)
			ultimo_segundo = segundo
			
		"Minuto":
			rotation = deg_to_rad(6 * fmod(segundo / 60, 60))
			
		"Hora":

			rotation = deg_to_rad(30 * fmod(segundo / 3600, 60))
