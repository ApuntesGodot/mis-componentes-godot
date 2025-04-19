extends Label
@export var Alarma : AudioStreamPlayer2D


func temporizadorAlerta(status):
	match status:
		true:
			text = "Tiempo finalizado"
			Alarma.play()
			await get_tree().create_timer(2.0).timeout
			Alarma.stop()
		false:
			text = "Tiempo en curso"
		null:
			text = "Reloj"
