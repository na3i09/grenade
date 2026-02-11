extends Node
class_name WeaponSwitcher


signal weapon_switched(weapon_id: int)


var slot_list: PackedStringArray = [
	&"slot_1",
	&"slot_2",
	&"slot_3",
	&"slot_4",
	#&"slot_5",
	#&"slot_6",
]

var current_weapon: int = 1

func _unhandled_input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		for slot in slot_list:
			if event.is_action_pressed(slot):
				weapon_switched.emit(slot.trim_prefix("slot_").to_int())
