extends Fuze
class_name RemoteFuze

@export var group_name: String

func _arm() -> void:
	add_to_group(group_name)

func trigger_remote(id: int) -> void:
	if id == get_parent().originator_id:
		_detonate()
