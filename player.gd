extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var cam_rotation: float = 0.0

@onready var camera_3d: Camera3D = $Camera3D

var throwing: bool = false
var starting_throw_strength: float = 6.0
var max_throw_strength: float = 15.0
var current_throw_strength: float = 0.0

@export var weapon_arm: Node3D
@onready var starting_charge_position: float = weapon_arm.position.z
@onready var max_charge_position: float = weapon_arm.position.z + 0.25

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	_set_camera.call_deferred()

func _set_camera() -> void:
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
		
		if throwing:
			_increase_throw_strength(delta)
			_charging_throw(delta)
		
		move_and_slide()

func _increase_throw_strength(delta: float) -> void:
	current_throw_strength = move_toward(current_throw_strength,max_throw_strength,5 * delta)

func _unhandled_input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		if event.is_action_pressed("exit_game"):
			$"../".exit_game(name.to_int())
			get_tree().quit()
			get_viewport().set_input_as_handled()
		if event.is_action_pressed("fire"):
			throwing = true
			current_throw_strength = starting_throw_strength
		if event.is_action_released("fire"):
			throwing = false
			weapon_arm.position.z = starting_charge_position
			var vel: Vector3 = -$Camera3D.basis.z * current_throw_strength
			$"../".throw_grenade(weapon_arm.global_position,vel)

func _charging_throw(delta: float) -> void:
	weapon_arm.position.z = move_toward(weapon_arm.position.z,max_charge_position,0.8 * delta)

func _on_camera_3d_set_cam_rotation(_rot: float) -> void:
	$PlayerBody.rotation.y = _rot
	cam_rotation = _rot

func _on_died() -> void:
	print("player " + name + " died")
	if is_multiplayer_authority():
		$"../".del_player(name.to_int(),$HurtBoxManager.last_hit_id)
		$"../Camera3D".set_deferred("current",true)
		$"../".show_respawn_button()
