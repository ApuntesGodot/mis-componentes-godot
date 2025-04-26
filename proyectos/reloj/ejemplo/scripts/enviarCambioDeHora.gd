extends Button
var utils = preload("res://utils/formatoNumerico.gd")

@export var reloj : ClockSystem

var Segu : LineEdit
var Minu : LineEdit 
var Hora : LineEdit 
var Modo : OptionButton 


	
signal notificarFormularioEnviado

func obtenerFormHora(H):
	Hora = H
	
func obtenerFormMinuto(M):
	Minu = M

func obtenerFormSegundo(S):
	Segu = S

func obtenerFormModo(m):
	Modo = m



			
signal solicitar_cambio_de_hora(h,m,s,v)


func _ready():
	self.solicitar_cambio_de_hora.connect(reloj.insertar_nueva_hora)
	
	#Segu.text = utils.formatear_digito(reloj.segundo_inicial)
	#Minu.text = utils.formatear_digito(reloj.minuto_inicial)
	#Hora.text = utils.formatear_digito(reloj.hora_inicial)
	


	
func _on_button_down():

	solicitar_cambio_de_hora.emit(
		float(Hora.text), 
		float(Minu.text), 
		float(Segu.text),
		Modo.get_item_text(Modo.get_selected())
		
	)
	
	notificarFormularioEnviado.emit()
