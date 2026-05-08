extends Area3D

@export var recurso_dialogo: DialogueResource
@export var titulo_dialogo: String = "inicio_npc"
@onready var player: CharacterBody3D = get_node('../../Player')
@onready var movement_handler: Node = get_node('../../Player/MovementHandler')

var jugador_cerca: bool = false
var charla_activa: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	print(player)
	print(movement_handler)
	body_exited.connect(_on_body_exited)
	DialogueManager.dialogue_ended.connect(_on_dialogue_finished)

func _input(event):
	if event.is_action_pressed("ui_accept") and jugador_cerca and not charla_activa:
		iniciar_charla()

func _on_body_entered(body):
	if body is CharacterBody3D:
		jugador_cerca = true

func _on_body_exited(body):
	if body is CharacterBody3D:
		jugador_cerca = false

func iniciar_charla():
	charla_activa = true
	
	if movement_handler:
		movement_handler.can_move = false
	
	if player:
		player.velocity = Vector3.ZERO
		
	DialogueManager.show_example_dialogue_balloon(recurso_dialogo, titulo_dialogo)

func _on_dialogue_finished(_resource: DialogueResource):
	charla_activa = false
	
	if movement_handler:
		movement_handler.can_move = true
