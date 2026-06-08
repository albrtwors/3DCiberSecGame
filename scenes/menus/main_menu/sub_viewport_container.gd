# CharacterPreview.gd
extends SubViewportContainer

@onready var marker_3d_viewport = $SubViewport/Marker3D
@onready var spawn_point = $SubViewport/Marker3D # Donde aparecerá el modelo

func mostrar_personaje(ruta_personaje: String, ruta_pelo: String):
	# 1. Limpiar mallas previas en el viewport
	for child in marker_3d_viewport.get_children():
		child.queue_free()
	
	# 2. Instanciar el nuevo cuerpo base (hombre o mujer)
	var personaje_instancia = load(ruta_personaje).instantiate()
	marker_3d_viewport.add_child(personaje_instancia)
	
	# 3. Validar si el usuario eligió un pelo (que no sea la opción vacío/calvo)
	if ruta_pelo != "":
		# Usamos get_node con la estructura interna exacta: "Character base/Skeleton3D/Bone_002"
		var nodo_hueso = personaje_instancia.get_node_or_null("Character base/Skeleton3D/Bone_002")
		if(!nodo_hueso):
			nodo_hueso = personaje_instancia.get_node_or_null("Character woman_001/Skeleton3D/Bone_002")
		
		if nodo_hueso:
			var pelo_escena = load(ruta_pelo)
			if pelo_escena:
				var pelo_instancia = pelo_escena.instantiate()
				pelo_instancia.name = "PeloPersonalizado"
				nodo_hueso.add_child(pelo_instancia)
		else:
			print("Error: No se encontró la jerarquía del Skeleton o el Bone_002 en este modelo.")
			
func _process(delta):
	if spawn_point.get_child_count() > 0:
		spawn_point.get_child(0).rotate_y(delta * 0.5)
