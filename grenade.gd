extends RigidBody3D
class_name Grenade


@export var ExplosionScene: PackedScene

@export var starting_velocity: Vector3 = Vector3(0,1,3)

var timer: Timer = Helpers.create_internal_timer(self,1.2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	
	timer.timeout.connect(_on_timer_timeout)
	
	linear_velocity = starting_velocity


func _on_timer_timeout() -> void:
	var explosion = ExplosionScene.instantiate()
	
	get_tree().get_root().add_child(explosion)
	explosion.global_position = global_position
	
	queue_free()
