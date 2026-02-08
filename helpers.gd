extends Object
class_name Helpers


static func create_internal_timer(parent: Node, wait_time: float = 1.0, one_shot: bool = true) -> Timer:
	var _timer: Timer = Timer.new()
	
	_timer.wait_time = wait_time
	_timer.one_shot = one_shot
	parent.add_child(_timer)
	
	return _timer
