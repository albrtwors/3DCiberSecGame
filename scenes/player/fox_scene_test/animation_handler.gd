extends Node


@onready var anim_player: AnimationPlayer = get_node('../fox/AnimationPlayer')

func play_animation(anim_name: String):
	anim_player.play(anim_name)
