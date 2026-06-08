extends Node

func _ready() -> void:
	# Esperamos un frame para asegurarnos de que los servidores ya corrieron su _ready()
	await get_tree().process_frame
	
	# Buscamos todas las instancias reales que estén en ese grupo
	var servidores_activos = get_tree().get_nodes_in_group("servidores")
	
	for servidor in servidores_activos:
		if servidor is ServerNode: # Aquí sí usamos la clase para validar el tipo
			servidor.money_generated.connect(_on_any_server_generated_money)

func _on_any_server_generated_money(amount: float) -> void:
	# Cada vez que CUALQUIER servidor genere plata, caerá aquí
	GlobalData.money+=amount
	print("Se recolectaron: $", amount, " de un servidor de la red.")
