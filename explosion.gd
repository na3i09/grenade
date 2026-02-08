extends Node3D


@export var size: float = 3.0
@export var duration: float = 0.2

var tween: Tween


func _ready() -> void:
	tween = create_tween()
	
	tween.finished.connect(_on_tween_finished)
	
	tween.tween_property($ScaleRoot,"scale",Vector3(1,1,1) * size,duration)


func _on_tween_finished() -> void:
	queue_free()
