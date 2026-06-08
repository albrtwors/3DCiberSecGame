# GlobalData.gd
extends Node


var selected_character_path: String = "res://scenes/player/skeleton_model_test/skeleton_2.tscn"
var selected_hair_path: String = "res://scenes/player/skeleton_model_test/skeleton_2.tscn"
var current_model: Node3D
var current_anim_player: AnimationPlayer

# Datos del personaje que persisten entre niveles
var nombre_jugador: String = "Frisk"
var nivel: int = 1
var xp: int = 0
var vida_max: float = 100.0
var vida_actual: float = 100.0

# Estadísticas de Ciberseguridad
var hacking_skill: int = 10
var firewall_power: int = 50

#Money
var money: float = 1000.00

# Inventario de ítems técnicos (ej. llaves, exploits)
var inventario: Array = []

func reset_personaje():
	vida_actual = vida_max
	# Otros valores iniciales si el jugador muere
