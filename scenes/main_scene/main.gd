extends Node

@onready var level_controller = $LevelController
@onready var ui_container = $UI
@onready var events = $EventController


var menu_principal_tscn: PackedScene = load("res://scenes/menus/main_menu/ui.tscn")

func _ready():
	EventController.cargar_nivel.connect(_on_cargar_nivel)
	EventController.level_completed.connect(_on_level_completed)
	mostrar_menu_principal()



func mostrar_menu_principal():
	limpiar_escena()
	var menu = menu_principal_tscn.instantiate()
	ui_container.add_child(menu)

func _on_cargar_nivel(ruta_nivel: String):
	limpiar_escena()
	var nivel_recurso = load(ruta_nivel)
	if nivel_recurso is PackedScene:
		var nuevo_nivel = nivel_recurso.instantiate()
		level_controller.add_child(nuevo_nivel)
	else:
		print("Error: La ruta no es una escena válida o no existe: ", ruta_nivel)

func limpiar_escena():
	# Elimina niveles previos
	for n in level_controller.get_children():
		n.queue_free()
	# Elimina UI previa (menús)
	for n in ui_container.get_children():
		n.queue_free()

func _on_level_completed(stats: Dictionary):
	print("El jugador hackeó el sistema con éxito.")
	limpiar_escena()
	# Aquí podrías usar stats["puzzles_completados"] para la UI
