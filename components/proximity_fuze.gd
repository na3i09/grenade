extends Fuze
class_name ProximityFuze

@export var trigger_area: Area3D
@export var trigger_shape: CollisionShape3D

func _ready() -> void:
	trigger_shape.disabled = true
	trigger_area.body_entered.connect(_on_trigger_area_body_entered)

func _arm() -> void:
	trigger_shape.disabled = false

func _on_trigger_area_body_entered(_body: Node3D) -> void:
	_detonate()
