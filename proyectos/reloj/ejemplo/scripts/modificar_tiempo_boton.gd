extends Button

@export var reloj : ClockSystem
@export_enum("Aumentar","Disminuir") var modoCambioTiempo: String 
#@export_enum("Reloj", "Temporizador") var modo: String = "Reloj"


var hora : LineEdit
var minuto : LineEdit
var segundo : LineEdit

var modo : OptionButton


func obtenerFormHora(H):
	hora = H
	
func obtenerFormMinuto(M):
	minuto = M

func obtenerFormSegundo(S):
	segundo = S
	
func obtenerFormModo(M):
	modo = M

	
func _ready():
	pass	
	
func _on_button_down():
	match modoCambioTiempo:
		"Aumentar":
			reloj.modificar_tiempo(
				int(hora.text), 
				int(minuto.text),
				int(segundo.text),
			)
		"Disminuir":
			reloj.modificar_tiempo(
				-1*int(hora.text), 
				-1*int(minuto.text),
				-1*int(segundo.text),
			)
	pass # Replace with function body.
