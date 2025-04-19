extends LineEdit

var utils = preload("res://utils/formatoNumerico.gd")

var oldtext = "00"

signal valorCambiado(valor: int)

func _ready():
	text = "00"
	focus_exited.connect(_on_focus_exited)

func _on_focus_exited():
	if text.is_valid_int():
		oldtext = utils.formatear_digito(text)
		text = oldtext
	else:
		text = utils.formatear_digito(oldtext)


func agregarCero(numString : String) -> String:
	if(numString.length()<2):
		numString = "0"+numString
		
	return numString
	
