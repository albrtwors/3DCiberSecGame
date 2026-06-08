extends Node

var anim_player: AnimationPlayer

func setup_references():
	anim_player = GlobalData.current_anim_player

func play_animation(anim_name: String):
	if anim_player and anim_player.has_animation(anim_name):
		anim_player.play(anim_name)
