extends Label
class_name HealthCounter


func _on_health_changed(new_value: float) -> void:
	text = str(snappedf(new_value,1))
