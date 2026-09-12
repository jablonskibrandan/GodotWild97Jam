class_name ThirdPersonPlayer
extends CharacterBody3D

@export_category("Movement")
@export var move_speed: float = 6.0
@export var sprint_speed: float = 10.0
@export var acceleration: float = 20.0
@export var deceleration: float = 25.0
@export var rotation_speed: float = 12.0

@export_category("Jump")
@export var jump_velocity: float = 7.0
@export var gravity_multiplier: float = 1.0

@export_category("Camera")
@export var mouse_sensitivity: float = 0.0025
@export_range(-89.0, 0.0, 1.0) var min_camera_angle: float = -60.0
@export_range(0.0, 89.0, 1.0) var max_camera_angle: float = 70.0

@onready var visuals: Node3D = $Visuals
@onready var camera_yaw: Node3D = $CameraYaw
@onready var camera_pitch: Node3D = $CameraYaw/CameraPitch

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_rotate_camera(event.relative)

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if event is InputEventMouseButton and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement(delta)
	move_and_slide()


func _handle_movement(delta: float) -> void:
	var input_vector := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var direction := Vector3.ZERO

	if input_vector.length() > 0.0:
		var camera_forward := -camera_yaw.global_basis.z
		var camera_right := camera_yaw.global_basis.x

		camera_forward.y = 0.0
		camera_right.y = 0.0

		camera_forward = camera_forward.normalized()
		camera_right = camera_right.normalized()

		direction = (
			camera_right * input_vector.x
			+ camera_forward * -input_vector.y
		).normalized()

	var current_speed := sprint_speed if Input.is_action_pressed("sprint") else move_speed

	if direction != Vector3.ZERO:
		velocity.x = move_toward(
			velocity.x,
			direction.x * current_speed,
			acceleration * delta
		)
		velocity.z = move_toward(
			velocity.z,
			direction.z * current_speed,
			acceleration * delta
		)

		_rotate_character(direction, delta)
	else:
		velocity.x = move_toward(
			velocity.x,
			0.0,
			deceleration * delta
		)
		velocity.z = move_toward(
			velocity.z,
			0.0,
			deceleration * delta
		)


func _rotate_character(direction: Vector3, delta: float) -> void:
	var target_angle := atan2(direction.x, direction.z)

	visuals.rotation.y = lerp_angle(
		visuals.rotation.y,
		target_angle,
		rotation_speed * delta
	)


func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * gravity_multiplier * delta


func _rotate_camera(mouse_delta: Vector2) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	camera_yaw.rotate_y(-mouse_delta.x * mouse_sensitivity)

	camera_pitch.rotation.x -= mouse_delta.y * mouse_sensitivity
	camera_pitch.rotation.x = clamp(
		camera_pitch.rotation.x,
		deg_to_rad(min_camera_angle),
		deg_to_rad(max_camera_angle)
	)
