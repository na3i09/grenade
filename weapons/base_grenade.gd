@abstract extends RigidBody3D
class_name BaseGrenade


@export var ExplosionScene: PackedScene

@export var starting_velocity: Vector3 = Vector3(0,1,3)

var originator_id: int = 0

func assign_starting_velocity(vel: Vector3) -> void:
	starting_velocity = vel
	linear_velocity = vel

func _explode() -> void:
	var explosion = ExplosionScene.instantiate()
	explosion.originator_id = originator_id
	get_tree().get_root().add_child(explosion)
	explosion.global_position = global_position
