extends CharacterBody3D

func _ready():
	# 1. Instanciar el modelo base del personaje
	var model_scene = load(GlobalData.selected_character_path)
	var model_instance = model_scene.instantiate()
	add_child(model_instance)
	
	# Guardar referencias globales
	GlobalData.current_model = model_instance
	GlobalData.current_anim_player = model_instance.get_node("AnimationPlayer")
	
	# 2. Instanciar el pelo si hay uno seleccionado
	if GlobalData.selected_hair_path != "":
		# Intentamos buscar el hueso en la estructura del hombre
		var nodo_hueso = model_instance.get_node_or_null("Character base/Skeleton3D/Bone_002")
		
		# Si da null, lo buscamos en la estructura de la mujer
		if nodo_hueso == null:
			nodo_hueso = model_instance.get_node_or_null("Character woman_001/Skeleton3D/Bone_002")
		
		# Si encontramos el hueso en cualquiera de los dos, añadimos el pelo
		if nodo_hueso:
			var pelo_scene = load(GlobalData.selected_hair_path)
			if pelo_scene:
				var pelo_instance = pelo_scene.instantiate()
				pelo_instance.name = "PeloPersonalizado"
				nodo_hueso.add_child(pelo_instance)
		else:
			print("Error en el juego: No se encontró Bone_002 para equipar el pelo.")

	# 3. Configurar referencias en los nodos hijos (como el CharacterHandler, armas, etc.)
	for child in get_children():
		if child.has_method("setup_references"):
			child.setup_references()
