extends Camera3D

signal set_cam_rotation(_rot: float)

var rot: Vector3 = Vector3.ZERO

@onready var initial_rot: Vector3 = rotation

const mouse_sensitivity: float = 1000.0

func _ready() -> void:
	if is_multiplayer_authority():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		rotation = rot
		
		set_cam_rotation.emit(rot.y)

func _unhandled_input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event is InputEventMouseMotion:
			camera_rotate_mouse(event)


func camera_rotate_mouse(event: InputEventMouseMotion) -> void:
	rot.y -= event.screen_relative.x / mouse_sensitivity
	rot.x -= (event.screen_relative.y / mouse_sensitivity)
