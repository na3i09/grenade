extends Resource
class_name NameList

@export var adjectives: PackedStringArray

@export var first_names: PackedStringArray

@export var titles: PackedStringArray


func generate_player_name() -> String:
	return _pick_name(adjectives) + " " + _pick_name(first_names) + " the " + _pick_name(titles)

func _pick_name(list: PackedStringArray) -> String:
	return list[randi() % list.size()]
