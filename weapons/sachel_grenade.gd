extends Grenade
class_name SachelGrenade


func _ready() -> void:
	super()
	body_entered.connect(_on_body_entered)
	armed.connect(_on_armed)


func _on_armed() -> void:
	contact_monitor = true

func _on_body_entered(_body: Node) -> void:
	freeze = true
