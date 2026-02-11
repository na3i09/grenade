extends BaseGrenade
class_name SachelGrenade


var timer: Timer = Helpers.create_internal_timer(self,0.3)

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


func _on_timer_timeout() -> void:
	contact_monitor = true

func _on_body_entered(_body: Node) -> void:
	freeze = true

func detonate(id: int) -> void:
	if id == originator_id:
		_explode()
		queue_free()
