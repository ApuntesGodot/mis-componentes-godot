extends OptionButton

@export var reloj : ClockSystem

signal emitirFormulario(formulario)
signal valorCambiado(index)
func _ready():
	emitirFormulario.emit(self)	
	
	for modo in reloj.MODOS_RELOJ:
		add_item(modo)
		
	var index = reloj.MODOS_RELOJ.find(reloj.modo)
	select(index)


func _on_item_selected(index):
	valorCambiado.emit(index)
