extends RigidBody3D
class_name Grenade


@export var ExplosionScene: PackedScene

var timer: Timer = Helpers.create_internal_timer(self,1.2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	
	timer.timeout.connect(_on_timer_timeout)
	
	linear_velocity = Vector3(0,1,3)


func _on_timer_timeout() -> void:
	var explosion = ExplosionScene.instantiate()
	
	get_tree().get_root().add_child(explosion)
	explosion.global_position = global_position
	
	queue_free()
