extends LineEdit

var oldtext = "0"

signal valorCambiado(valor: int)

func _ready():
	text = "0"
	focus_exited.connect(_on_focus_exited)

func _on_focus_exited():
	if text.is_valid_int():
		oldtext = text
	else:
		text = oldtext
	
