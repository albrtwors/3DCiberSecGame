extends Control

@onready var name_label = $PlayerInfo/Name
@onready var fade_overlay = $FadeOverlay # Tu nuevo ColorRect negro
@onready var money_label = $PlayerInfo/Money/Label
func _ready() -> void:
	# Asignar el nombre del jugador
	name_label.text = GlobalData.nombre_jugador
	
	# Iniciar el efecto de Fade In
	iniciar_fade_in()
	money_label.text = str(GlobalData.money) + ' $'

func iniciar_fade_in() -> void:
	# Aseguramos que el overlay sea visible y empiece totalmente opaco (negro)
	fade_overlay.show()
	fade_overlay.modulate.a = 1.0
	
	# Creamos un Tween para animar la propiedad de opacidad (alfa)
	var tween = create_tween()
	
	# Transición: anima el canal 'alpha' (a) del modulate hacia 0.0 en 1.5 segundos
	tween.tween_property(fade_overlay, "modulate:a", 0.0, 2.5)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	
	# Cuando la animación termine, escondemos el nodo para que no interfiera con los clics del mouse
	tween.tween_callback(fade_overlay.hide)

func _process(delta: float) -> void:
	money_label.text = str(GlobalData.money) + ' $'
# Quitamos _process ya que no lo estás usando, así ahorramos recursos en el juego
