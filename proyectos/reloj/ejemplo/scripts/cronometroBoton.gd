extends Button

var utils = preload("res://utils/formatoNumerico.gd")

@export var reloj : ClockSystem
@export var labelTiempos : Label

var modo
var modoActual

func _ready():
	
	modoActual = reloj.MODOS_RELOJ[modo.get_selected()]
	recibirSubmit()
	modo.valorCambiado.connect(modo_cambiado)
#	modo.connect(_on_opcion_cambiada)

func recibirSubmit():
	if modoActual == "Temporizador":
		disabled = true
	elif modoActual == "Reloj":
		disabled = false
	labelTiempos.text = ""
	
func modo_cambiado(index):
	modoActual = reloj.MODOS_RELOJ[index]
		
func obtenerFormModo(M):
	modo = M
	
func _on_button_down():
	var total_segundos = reloj.segundos_transcurridos + reloj.hora_inicial * 60 * 60 + reloj.minuto_inicial * 60 + reloj.segundo_inicial

	var Horas = int(total_segundos / 3600)
	var Minutos = int((total_segundos % 3600) / 60)
	var Segundos = int(total_segundos % 60)

	labelTiempos.text= labelTiempos.text+""+utils.formatear_digito(Horas)+":"+utils.formatear_digito(Minutos)+":"+utils.formatear_digito(Segundos)+"\n"
