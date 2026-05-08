extends Control

@onready var name_label = $Name
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = GlobalData.nombre_jugador


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
