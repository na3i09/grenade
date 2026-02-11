extends RigidBody3D
class_name Grenade

signal armed

@export var ExplosionScene: PackedScene

@export var starting_velocity: Vector3 = Vector3(0,1,3)

@export var fuze: Fuze

@export var arming_time: float = 0.2

@onready var arming_timer: Timer = Helpers.create_internal_timer(self,arming_time)

var originator_id: int = 0

func _ready() -> void:
	arming_timer.timeout.connect(_arm)
	armed.connect(fuze._on_armed)
	fuze.detonate.connect(_detonate)
	
	arming_timer.start()

func assign_starting_velocity(vel: Vector3) -> void:
	starting_velocity = vel
	linear_velocity = vel

func _explode() -> void:
	var explosion = ExplosionScene.instantiate()
	explosion.originator_id = originator_id
	get_tree().get_root().add_child(explosion)
	explosion.global_position = global_position

func _detonate() -> void:
	_explode()
	queue_free()

func _arm() -> void:
	armed.emit()
