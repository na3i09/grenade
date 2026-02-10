extends BaseGrenade
class_name TimeGrenade


var timer: Timer = Helpers.create_internal_timer(self,1.2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	_explode()
	
	queue_free()
