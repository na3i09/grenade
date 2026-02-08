extends Node
class_name HitBoxManager

signal hit_succeeded(gain: int)
signal got_blocked()

@export var rotation_root: Node3D
@export var mesh_root: Node3D
var hit_boxes: Array[Node]

func _ready() -> void:
	if mesh_root:
		hit_boxes = mesh_root.find_children("HitBox")
		_set_originator(self)

func _set_originator(origin: HitBoxManager) -> void:
	for box in hit_boxes:
		box.originator = origin

func unregister_skill() -> void:
	for hit_box in hit_boxes:
		hit_box.current_skill = null

func make_active() -> void:
	for hit_box in hit_boxes:
		if hit_box.current_skill:
			hit_box.find_child("CollisionShape3D").disabled = false

func make_inactive() -> void:
	for hit_box in hit_boxes:
		hit_box.find_child("CollisionShape3D").disabled = true

func successful_hit(gain: int):
	hit_succeeded.emit(gain)

func hit_blocked() -> void:
	got_blocked.emit()
