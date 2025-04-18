extends CanvasLayer 

@export var reloj : ClockSystem

@export var Segu : LineEdit
@export var Minu : LineEdit 
@export var Hora : LineEdit 
 
signal solicitar_cambio_de_hora(h,m,s)

func _ready():
	self.solicitar_cambio_de_hora.connect(reloj.insertar_nueva_hora)
	
func _on_button_down():
	solicitar_cambio_de_hora.emit(float(Hora.text),float(Minu.text),float(Segu.text))
