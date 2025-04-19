class_name revisar_formato 

static func formatear_digito(texto,largo : int = 2, relleno = "0") -> String:
	texto = str(texto)
	while texto.length() < largo:
		texto = relleno + texto

	return texto
