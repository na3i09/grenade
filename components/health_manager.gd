extends Node
class_name HealthManager

signal health_depleated
signal health_changed(new_value: float)

@export var max_health: float = 100
@onready var health: float = max_health:
	get:
		return health
	set(value):
		if value < 0:
			health = 0
		elif value > max_health:
			health = max_health
		else:
			health = value

@export var hurt_box_manager: HurtBoxManager

# TODO: consider combining with HurtBoxManager
func _ready() -> void:
	hurt_box_manager.hit.connect(_on_took_damage)

func _on_took_damage(damage: float) -> void:
	health -= damage
	
	health_changed.emit(health)
	
	if health <= 0:
		health_depleated.emit()
