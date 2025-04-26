extends LineEdit

@export var reloj : ClockSystem
@export_enum("Hora", "Minuto", "Segundo") var tipoFormulario: String

var utils = preload("res://utils/formatoNumerico.gd")

var oldtext = "00"

signal valorCambiado(valor: int)
signal emitirFormulario(formulario)

@export var valor_default = "00"
@export var min_length = 2
@export_enum ("int","float") var tipo = "int"

func _ready():
	emitirFormulario.emit(self)	
	
	text = utils.formatear_digito(valor_default,min_length)
	oldtext = text
	if(tipo == "int"):
		focus_exited.connect(_on_focus_exited)
	elif(tipo == "float"):
		focus_exited.connect(_on_focus_exited_float)
	
	match tipoFormulario:
		"Segundo":
			text = str(reloj.segundo_inicial)
		"Minuto":
			text = str(reloj.minuto_inicial)

		"Hora":
			text = str(reloj.hora_inicial)

func _on_focus_exited():
	if text.is_valid_int():
		oldtext = utils.formatear_digito(text,min_length)
		text = oldtext
	else:
		text = utils.formatear_digito(oldtext,min_length)

func _on_focus_exited_float():
	if text.is_valid_float():
		oldtext = utils.formatear_digito(text,min_length)
		text = oldtext
	else:
		text = utils.formatear_digito(oldtext,min_length)


func agregarCero(numString : String) -> String:
	if(numString.length()<2):
		numString = "0"+numString
		
	return numString
	
