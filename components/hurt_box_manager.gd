extends Node
class_name HurtBoxManager

signal hit(damage: float)

@export var mesh_root: Node3D
var hurt_boxes: Array[Node]
var hurt_box_shapes: Array[Node]

## Default time between allowing repeated hits
@export var hit_time: float = 0.8

var last_hit_id: int

@onready var hit_timer: Timer = Helpers.create_internal_timer(self, hit_time)

func _ready() -> void:
	if mesh_root:
		hurt_boxes = mesh_root.find_children("HurtBox")
		_connect_area_entered_signals()
		_find_shapes()

func _connect_area_entered_signals() -> void:
	for hurt in hurt_boxes:
		hurt.area_entered.connect(_on_got_hit)

func _disconnect_area_entered_signals() -> void:
	for hurt in hurt_boxes:
		hurt.area_entered.disconnect(_on_got_hit)

func _find_shapes() -> void:
	hurt_box_shapes.clear()
	for hurt in hurt_boxes:
		hurt_box_shapes += hurt.find_children("CollisionShape3D")

func enable_hurt_boxes() -> void:
	for hurt in hurt_box_shapes:
		hurt.disabled = false


func disable_hurt_boxes() -> void:
	for hurt in hurt_box_shapes:
		hurt.disabled = true


func _on_got_hit(area: Area3D) -> void:
	if area is HitBox:
		if hit_timer.is_stopped():
			last_hit_id = area.originator_id
			hit.emit(area.damage)
