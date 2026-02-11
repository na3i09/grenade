extends Fuze
class_name TimeFuze

@export var fuze_time: float = 1.2

@onready var timer: Timer = Helpers.create_internal_timer(self,fuze_time)

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)

func _arm() -> void:
	timer.start()

func _on_timer_timeout() -> void:
	_detonate()
