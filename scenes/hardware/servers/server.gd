class_name ServerNode
extends Node3D

# --- SEÑALES ---
signal money_generated(amount: float)
signal server_attacked()
signal server_purchased()

# --- REFERENCIAS EXPORTADAS ---
@export_group("Componentes")
@export var interaction_area: Area3D 

@export_subgroup("Zona de Compra")
@export var purchase_area_root: Node3D 
@export var purchase_detector: Area3D 
@export var price_label: Label3D 

# --- CONFIGURACIÓN DE IDENTIDAD & ECONOMÍA (Exportadas para configurar por servidor) ---
@export_group("Datos del Servidor (JSON/SaveData)")
@export var server_id: String = "srv_01" ## ID único para guardar/cargar partida (ej: srv_rack_A1).
@export var server_name: String = "Servidor Proxy Principal" ## Nombre legible para la UI.
@export var location_description: String = "Rack Alfa - Pasillo Izquierdo" ## Lugar exacto para las alertas del SOC.
@export var server_purchase_cost: float = 150.0 

@export_group("Balance de Producción")
@export var base_money_per_second: float = 1.0
@export var upgrade_cost_multiplier: float = 1.5

@export_group("Seguridad")
@export var attack_check_interval: float = 5.0
@export_range(0.0, 1.0) var attack_chance: float = 0.15

# --- ESTADO INTERNO DEL SERVIDOR ---
@export_group("Estado Inicial")
@export var is_purchased: bool = false

var current_level: int = 1
var max_level: int = 10
var base_upgrade_cost: float = 50.0

# Timers internos
var money_timer: Timer
var attack_timer: Timer

func _ready() -> void:
	_setup_interaction()
	_setup_purchase_zone()
	_setup_timers()
	
	if is_purchased:
		_start_server_operations()

# --- CONFIGURACIÓN DE INTERACCIÓN ---
func _setup_interaction() -> void:
	if interaction_area:
		interaction_area.input_ray_pickable = true
		interaction_area.input_event.connect(_on_interaction_area_input_event)
	else:
		push_warning("Falta 'interaction_area' (Click) en: ", name)

func _setup_purchase_zone() -> void:
	if is_purchased:
		_clean_purchase_zone()
		return

	if price_label:
		price_label.text = "$ " + str(server_purchase_cost)
	else:
		push_warning("Falta 'price_label' en: ", name)

	if purchase_detector:
		purchase_detector.body_entered.connect(_on_purchase_area_body_entered)
	else:
		push_warning("Falta 'purchase_detector' (Area3D) en: ", name)

# --- CONFIGURACIÓN DE TIMERS ---
func _setup_timers() -> void:
	money_timer = Timer.new()
	money_timer.wait_time = 15.0 
	money_timer.autostart = false 
	money_timer.timeout.connect(_generate_money)
	add_child(money_timer)
	
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_check_interval
	attack_timer.autostart = false 
	attack_timer.timeout.connect(_check_for_attacks)
	add_child(attack_timer)

# --- LÓGICA DE COMPRA ---

func _on_purchase_area_body_entered(body: Node3D) -> void:
	if is_purchased:
		return
		
	if body.is_in_group("player") or body.name == "Player":
		_try_to_purchase()

func _try_to_purchase() -> void:
	if GlobalData.money < server_purchase_cost:
		return
	GlobalData.money-=server_purchase_cost
	is_purchased = true
	server_purchased.emit()
	print_rich("[color=green][SISTEMA][/color] ¡%s adquirido por $%s!" % [server_name, server_purchase_cost])
	
	_start_server_operations()
	_clean_purchase_zone()

func _clean_purchase_zone() -> void:
	if purchase_area_root:
		purchase_area_root.queue_free()

func _start_server_operations() -> void:
	money_timer.start()
	attack_timer.start()
	print("%s en línea. Ubicación: %s" % [server_name, location_description])

# --- LÓGICA CORE ---

func get_current_generation() -> float:
	return base_money_per_second * current_level

func get_upgrade_cost() -> float:
	return base_upgrade_cost * pow(upgrade_cost_multiplier, current_level - 1)

func _generate_money() -> void:
	var money_produced = get_current_generation()
	money_generated.emit(money_produced)
	print("%s generó tic de: $%s (Nivel %d)" % [server_name, money_produced, current_level])

func _check_for_attacks() -> void:
	if randf() < attack_chance:
		_handle_attack()

func _handle_attack() -> void:
	server_attacked.emit()
	# Alerta detallada usando el formato enriquecido de Godot
	print_rich("[color=red][INCIDENTE SOC][/color] ¡Ataque detectado en [b]%s[/b]! Ubicación: [i]%s[/i]" % [server_name, location_description])

# --- SISTEMA DE MEJORAS (Upgrades) ---

func upgrade_server() -> bool:
	if not is_purchased:
		return false
		
	if current_level >= max_level:
		print("Servidor al nivel máximo (10).")
		return false
		
	current_level += 1
	print("¡%s mejorado al nivel %d! Siguiente costo: $%s" % [server_name, current_level, get_upgrade_cost()])
	return true

# --- INTERACCIÓN ---

func _on_interaction_area_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_purchased:
			_open_upgrade_menu()
		else:
			print("No puedes mejorar un servidor que no has comprado.")

func _open_upgrade_menu() -> void:
	print("--- Abriendo Menú de Mejoras para: %s ---" % server_name)
	print("Nivel actual: %d | Costo de mejora: $%s" % [current_level, get_upgrade_cost()])


# ==========================================
# --- SISTEMA DE GUARDADO / SERIALIZACIÓN ---
# ==========================================

## Exporta los datos actuales del servidor en formato Diccionario (JSON-ready)
func get_server_data() -> Dictionary:
	return {
		"id": server_id,
		"name": server_name,
		"location": location_description,
		"is_purchased": is_purchased,
		"current_level": current_level
	}

## Carga los datos guardados desde un Diccionario
func load_server_data(data: Dictionary) -> void:
	if data.has("is_purchased"):
		is_purchased = data["is_purchased"]
	if data.has("current_level"):
		current_level = data["current_level"]
	
	# Si al cargar la partida ya estaba comprado, aseguramos su flujo de inmediato
	if is_purchased:
		_start_server_operations()
		_clean_purchase_zone()
