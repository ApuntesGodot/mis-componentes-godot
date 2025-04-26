extends Button

@export var reloj : ClockSystem
@export var VelocidadForm : LineEdit



func _on_button_down():
	reloj.cambiarVelocidad(float(VelocidadForm.text))
