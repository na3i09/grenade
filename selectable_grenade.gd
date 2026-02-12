extends Grenade
class_name SelectableGrenade


enum FuzeTypes {
	TIME_FUZE = 1,
	CONTACT_FUZE = 2,
	REMOTE_FUZE = 3,
}

@export_enum("Time Fuze:1","Contact Fuze:2","Remote Fuze:3") var fuze_type: int = 1

@export var fuze_time: float = 1.2

func _ready() -> void:
	_create_fuze()
	super()

func _create_fuze() -> void:
	match fuze_type:
		FuzeTypes.TIME_FUZE:
			fuze = TimeFuze.new()
			fuze.fuze_time = fuze_time
		FuzeTypes.CONTACT_FUZE:
			fuze = ContactFuze.new()
			fuze.contact_body = self
		FuzeTypes.REMOTE_FUZE:
			fuze = RemoteFuze.new()
			fuze.group_name = "Sachels"
	add_child(fuze)
