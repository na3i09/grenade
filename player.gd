extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var cam_rotation: float = 0.0

@onready var camera_3d: Camera3D = $Camera3D


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	camera_3d.current = is_multiplayer_authority()

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("player_left","player_right","player_forward","player_back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction = direction.rotated(Vector3.UP,cam_rotation + rotation.y)
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event.is_action_pressed("exit_game"):
			$"../".exit_game(name.to_int())
			get_tree().quit()
		if event.is_action_pressed("fire"):
			var vel: Vector3 = -$Camera3D.basis.z * 12
			$"../".throw_grenade(global_position,vel)

func _on_camera_3d_set_cam_rotation(_rot: float) -> void:
	cam_rotation = _rot
