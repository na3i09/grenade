@abstract extends RigidBody3D
class_name BaseGrenade


@export var ExplosionScene: PackedScene

@export var starting_velocity: Vector3 = Vector3(0,1,3)


func _explode() -> void:
	var explosion = ExplosionScene.instantiate()
	
	get_tree().get_root().add_child(explosion)
	explosion.global_position = global_position
