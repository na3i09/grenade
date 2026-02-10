extends BaseGrenade
class_name ContactGrenade


var timer: Timer = Helpers.create_internal_timer(self,0.3)

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
	linear_velocity = starting_velocity


func _on_timer_timeout() -> void:
	$Area3D/CollisionShape3D.disabled = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	_explode()
	queue_free()
