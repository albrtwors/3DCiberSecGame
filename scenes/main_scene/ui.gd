# MenuPrincipal.gd
extends Control

@export var primer_laboratorio = "res://scenes/test_levels/test_1/level.tscn"
@onready var character_menu = $CharacterMenu
@onready var main_menu = $MainMenu
@onready var preview_3d = $CharacterMenu/HBoxContainer/VBoxContainer/SubViewportContainer

# Diccionario para mapear los modelos base por género
var modelos_base = CustomizationItems.MODELS

# Estado actual del personaje
var genero_actual = "mujer" # Género por defecto al iniciar
var indice_pelo_seleccionado = 0

# Base de datos de pelos (Array de Diccionarios)
# "genero" puede ser: "hombre", "mujer" o "unisex" (si lo comparten ambos)
var base_datos_pelos = CustomizationItems.HAIRS
	

# Arreglo dinámico que guardará sólo los pelos que correspondan al género actual
var pelos_filtrados = []

func _ready():
	character_menu.hide()
	main_menu.show()
	
	# Inicializar el menú con el género por defecto
	seleccionar_genero("mujer")

func _on_BotonJugar_pressed():
	EventController.emit_signal("cargar_nivel", primer_laboratorio)

func _on_level_2_pressed():
	EventController.emit_signal("cargar_nivel", "res://scenes/test_levels/test_1/level2.tscn")

func _on_new_game_start_pressed():
	main_menu.hide()
	character_menu.show()

### NUEVO: SELECCIÓN DIRECTA DE GÉNERO (Reemplaza a next/prev character)
# Conecta esto al botón de seleccionar personaje Masculino
func _on_male_selected_pressed():
	seleccionar_genero("hombre")

# Conecta esto al botón de seleccionar personaje Femenino
func _on_female_selected_pressed():
	seleccionar_genero("mujer")

# Función encargada de cambiar el género y actualizar las listas de accesorios
func seleccionar_genero(nuevo_genero: String):
	genero_actual = nuevo_genero
	GlobalData.selected_character_path = modelos_base[genero_actual]
	
	# Filtrar la base de datos de pelos según el género seleccionado o si es unisex
	filtrar_pelos_por_genero()
	
	# Reiniciar el índice del pelo para evitar desbordamientos si la lista cambia de tamaño
	indice_pelo_seleccionado = 0
	
	# Guardar el pelo por defecto en el GlobalData
	if pelos_filtrados.size() > 0:
		GlobalData.selected_hair_path = pelos_filtrados[indice_pelo_seleccionado]["ruta"]
	else:
		GlobalData.selected_hair_path = ""
		
	actualizar_previsualizacion()

# Llena el arreglo temporal con los pelos válidos para el género actual
func filtrar_pelos_por_genero():
	pelos_filtrados.clear()
	for pelo in base_datos_pelos:
		if pelo["genero"] == genero_actual or pelo["genero"] == "unisex":
			pelos_filtrados.append(pelo)

### CONFIGURACIÓN DE PELO (Usa la lista filtrada)
func _on_next_hair_pressed():
	if pelos_filtrados.is_empty(): return
	
	indice_pelo_seleccionado = (indice_pelo_seleccionado + 1) % pelos_filtrados.size()
	GlobalData.selected_hair_path = pelos_filtrados[indice_pelo_seleccionado]["ruta"]
	actualizar_previsualizacion()

func _on_prev_hair_pressed():
	if pelos_filtrados.is_empty(): return
	
	indice_pelo_seleccionado = (indice_pelo_seleccionado - 1 + pelos_filtrados.size()) % pelos_filtrados.size()
	GlobalData.selected_hair_path = pelos_filtrados[indice_pelo_seleccionado]["ruta"]
	actualizar_previsualizacion()

# Envía los datos limpios al viewport
func actualizar_previsualizacion():
	var ruta_modelo = modelos_base[genero_actual]
	var ruta_pelo = ""
	
	if pelos_filtrados.size() > 0:
		ruta_pelo = pelos_filtrados[indice_pelo_seleccionado]["ruta"]
		
	preview_3d.mostrar_personaje(ruta_modelo, ruta_pelo)

func _on_line_edit_text_changed(new_text: String) -> void:
	GlobalData.nombre_jugador = new_text
