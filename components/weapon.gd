extends Resource
class_name Weapon

@export var ProjectileScene: PackedScene
@export var ViewModelScene: PackedScene

@export var display_name: String

@export_group("Settings")
@export var time_between_shots: float = 0.5
@export var starting_velocity: float = 6.0
@export var use_charging: bool = true
@export var max_charge_velocity: float = 15.0
@export var charge_speed: float = 5.0


static func generate_weapon_dict(weapon_array: Array[Weapon]) -> Dictionary[int,Weapon]:
	var dict: Dictionary[int,Weapon]
	var counter: int = 1
	
	for weap in weapon_array:
		dict[counter] = weap
		counter += 1
	
	return dict
