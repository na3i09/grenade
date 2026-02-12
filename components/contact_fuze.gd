extends Fuze
class_name ContactFuze

@export var contact_body: RigidBody3D


func _arm() -> void:
	contact_body.body_entered.connect(_on_body_entered)
	contact_body.contact_monitor = true
	contact_body.max_contacts_reported = 1


func _on_body_entered(_body: Node3D) -> void:
	_detonate()
