# GlobalData.gd
extends Node

# Datos del personaje que persisten entre niveles
var nombre_jugador: String = "Aria Vance"
var nivel: int = 1
var xp: int = 0
var vida_max: float = 100.0
var vida_actual: float = 100.0

# Estadísticas de Ciberseguridad
var hacking_skill: int = 10
var firewall_power: int = 50

# Inventario de ítems técnicos (ej. llaves, exploits)
var inventario: Array = []

func reset_personaje():
	vida_actual = vida_max
	# Otros valores iniciales si el jugador muere
