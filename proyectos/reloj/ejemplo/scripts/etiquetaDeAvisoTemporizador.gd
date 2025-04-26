extends Label
@export var Alarma : AudioStreamPlayer2D


func temporizadorAlerta(status):
	match status:
		true:
			Alarma.play()
			text = "Tiempo finalizado"
			await get_tree().create_timer(2.0).timeout
			Alarma.stop()
		false:
			Alarma.stop()
			text = "Tiempo en curso"
		null:
			text = "Reloj"
