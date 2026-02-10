extends Node3D
class_name WeaponModelSwitcher

@export var mesh_dict: Dictionary[int,Node3D]

var current_weapon_id: int = 1

func _ready() -> void:
	for mesh in mesh_dict.values():
		mesh.visible = false
	
	mesh_dict[current_weapon_id].visible = true

func _on_weapon_switched(weapon_id: int) -> void:
	rpc("_switch_weapon_model",weapon_id)

@rpc("any_peer","call_local")
func _switch_weapon_model(weapon_id:int) -> void:
	mesh_dict[current_weapon_id].visible = false
	mesh_dict[weapon_id].visible = true
	current_weapon_id = weapon_id
