@abstract extends Node3D
class_name Fuze

signal detonate

var armed: bool = false

func _detonate() -> void:
	detonate.emit()

func _on_armed() -> void:
	armed = true
	_arm()

@abstract func _arm() -> void
