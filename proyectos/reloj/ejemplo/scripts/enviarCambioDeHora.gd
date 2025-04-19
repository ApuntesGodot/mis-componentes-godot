extends Button
var utils = preload("res://utils/formatoNumerico.gd")

@export var reloj : ClockSystem

@export var Segu : LineEdit
@export var Minu : LineEdit 
@export var Hora : LineEdit 
@export var Modo : OptionButton 

@export var Cronometro : Button 
@export var ListadoCronometro : Label

signal solicitar_cambio_de_hora(h,m,s)

func _ready():
	self.solicitar_cambio_de_hora.connect(reloj.insertar_nueva_hora)
	Segu.text = utils.formatear_digito(reloj.segundo_inicial)
	Minu.text = utils.formatear_digito(reloj.minuto_inicial)
	Hora.text = utils.formatear_digito(reloj.hora_inicial)
	
	for modo in reloj.MODOS_RELOJ:
		Modo.add_item(modo)
		
	var index = reloj.MODOS_RELOJ.find(reloj.modo)
	Modo.select(index)

	
func _on_button_down():
	# Control de modo
	if(Modo.get_item_text(Modo.get_selected())=="Temporizador"):
		Cronometro.disabled = true
		ListadoCronometro.text = ""
	else:
		Cronometro.disabled = false
	
	
	# Enviar nueva hora y modo
	solicitar_cambio_de_hora.emit(
		float(Hora.text), float(Minu.text), float(Segu.text),
		Modo.get_item_text(Modo.get_selected())
	)
