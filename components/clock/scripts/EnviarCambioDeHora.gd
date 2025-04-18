extends Button

@export var reloj : ClockSystem

@export var Segu : LineEdit
@export var Minu : LineEdit 
@export var Hora : LineEdit 
 
signal solicitar_cambio_de_hora(h,m,s)

func _ready():
	self.solicitar_cambio_de_hora.connect(reloj.insertar_nueva_hora)
	Segu.text = str(reloj.segundo_inicial)
	Minu.text = str(reloj.minuto_inicial)
	Hora.text = str(reloj.hora_inicial)
	
	
func _on_button_down():
	solicitar_cambio_de_hora.emit(float(Hora.text),float(Minu.text),float(Segu.text)-1)
