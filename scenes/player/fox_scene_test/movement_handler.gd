extends Node

@export_group("Configuración de Movimiento")
@export var speed: float = 5.0
@export var acceleration: float = 15.0
@export var rotation_speed: float = 10.0
@export var can_move: bool = true

@onready var animation_handler: Node = get_node('../AnimationHandler')
@onready var parent: CharacterBody3D = get_parent()

# Ya no usamos @onready con ruta fija, usamos una variable simple
var model_node: Node3D 

func setup_references():
	model_node = GlobalData.current_model

func _physics_process(delta: float) -> void:
	# Verificamos que el modelo exista antes de mover
	if not parent or not model_node:
		return
	if not can_move:
		return

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	

	if not parent.is_on_floor():
		parent.velocity += parent.get_gravity() * delta

	if direction:
		animation_handler.play_animation('running')
		parent.velocity.x = move_toward(parent.velocity.x, direction.x * speed, acceleration * delta)
		parent.velocity.z = move_toward(parent.velocity.z, direction.z * speed, acceleration * delta)
		
		var target_look = model_node.global_position - direction
		target_look.y = model_node.global_position.y
		
		var target_basis = model_node.global_transform.looking_at(target_look, Vector3.UP).basis
		model_node.basis = model_node.basis.slerp(target_basis, rotation_speed * delta)
	else:
		animation_handler.play_animation('idle')
		parent.velocity.x = move_toward(parent.velocity.x, 0, acceleration * delta)
		parent.velocity.z = move_toward(parent.velocity.z, 0, acceleration * delta)

	parent.move_and_slide()
