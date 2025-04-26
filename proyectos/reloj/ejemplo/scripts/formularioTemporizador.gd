extends Node2D

signal configurarAlarma(dt)
@export var Alarma : AudioStreamPlayer2D

func _ready():
	var Temporizador
	if $Temporizador:
		Temporizador = $Temporizador
	elif $TemporizadorStandAlone:
		Temporizador =	$TemporizadorStandAlone
				
	$LineEdit.text = str(Temporizador.DuracionTemporizador)
	
func recibirAlarma(status, tiempoRestante):
	if !status:
		$Tiempo.text = ("TIEMPO ACABADO!!")

		$AudioStreamPlayer2D.play()
		await get_tree().create_timer(2.0).timeout
		$AudioStreamPlayer2D.stop()
		
	elif status:
		$Tiempo.text = "TIEMPO RESTANTE "+str(tiempoRestante)
	else:		
		$Tiempo.text =""	
		
func _on_button_button_down():
	print("TEST?")
	configurarAlarma.emit(int($LineEdit.text))
