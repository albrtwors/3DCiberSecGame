# MenuPrincipal.gd
extends Control

@export var primer_laboratorio = "res://scenes/test_levels/test_1/level.tscn"
@onready var character_menu = $CharacterMenu
@onready var main_menu = $MainMenu

func _ready():
	character_menu.hide()
	main_menu.show()

func _on_BotonJugar_pressed():
	get_node("../../EventController").emit_signal("cargar_nivel", primer_laboratorio)

func _on_level_2_pressed():
	get_node("../../EventController").emit_signal("cargar_nivel", "res://scenes/test_levels/test_1/level2.tscn")


func _on_new_game_start_pressed():
	main_menu.hide()
	character_menu.show()


func _on_line_edit_text_changed(new_text: String) -> void:
	GlobalData.nombre_jugador=new_text
