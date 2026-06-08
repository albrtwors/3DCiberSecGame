extends Node

@onready var area_3d = $"../Area3D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_level_complete():
	EventController.level_completed.emit({"hola":"asd"})

func _process(delta: float) -> void:
	pass




func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		EventController.level_completed.emit({})
