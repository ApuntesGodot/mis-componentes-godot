extends Button

var utils = preload("res://utils/formatoNumerico.gd")

@export var reloj : ClockSystem
@export var labelTiempos : Label

func _on_button_down():
	var total_segundos = reloj.segundos_transcurridos + reloj.hora_inicial * 60 * 60 + reloj.minuto_inicial * 60 + reloj.segundo_inicial

	var Horas = int(total_segundos / 3600)
	var Minutos = int((total_segundos % 3600) / 60)
	var Segundos = int(total_segundos % 60)

	labelTiempos.text= labelTiempos.text+""+utils.formatear_digito(Horas)+":"+utils.formatear_digito(Minutos)+":"+utils.formatear_digito(Segundos)+"\n"
