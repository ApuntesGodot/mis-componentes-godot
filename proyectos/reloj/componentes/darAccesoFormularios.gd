class_name formularios extends Node

@export var reloj: ClockSystem

@export var formularioSegundo : LineEdit
@export var formularioMinuto : LineEdit
@export var formularioHora : LineEdit
@export var formularioModo : OptionButton
@export var formularioVelocidad : LineEdit

@export var formularios_suscritos: Array[Node]

@export var boton_enviar_formulario : Button

@export var formularios_submit_suscritos: Array[Node]


func _ready():
	

	for fs in formularios_suscritos:
		if fs.has_method("obtenerFormSegundo"):
			formularioSegundo.emitirFormulario.connect(fs.obtenerFormSegundo)

		if fs.has_method("obtenerFormMinuto"):
			formularioMinuto.emitirFormulario.connect(fs.obtenerFormMinuto)

		if fs.has_method("obtenerFormHora"):	
			formularioHora.emitirFormulario.connect(fs.obtenerFormHora)
	
		if fs.has_method("obtenerFormModo"):
			formularioModo.emitirFormulario.connect(fs.obtenerFormModo)
		
		if fs.has_method("obtenerFormVelocidad"):
			formularioModo.emitirFormulario.connect(fs.obtenerFormVelocidad)
	
	# Cuando se pulsa el boton de enviar formulario, 
	# Notificar a los demas nodos de que se ha hecho un submit
	for fss in formularios_submit_suscritos:
		if fss.has_method("recibirSubmit"):
			boton_enviar_formulario.notificarFormularioEnviado.connect(fss.recibirSubmit)
