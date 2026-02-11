extends Label


func _on_weapon_switched(weapon_id: int) -> void:
	text = str(weapon_id)
