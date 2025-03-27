extends Node3D



@export var mouse_position_label: Label
@export var mouse_delta_label: Label

var camera: Camera3D

var window_width: int
var window_height: int

var current_mouse_position: Vector2
var delta_mouse_position: Vector2

var can_edge_pan: bool = true

var is_dragging_camera: bool = false
var is_rotating_camera: bool = false
var is_key_panning: bool = false

const EDGE_PAN_BORDER: int = 40
const CAMERA_SPEED: int = 10
const ROTATION_SPEED: float = 0.2
const ZOOM_SPEED: float = 40.0
const MIN_ZOOM: float = 0.5
const MAX_ZOOM: float = 30.0





func _ready() -> void:
	set_window_dimensions()
	
	camera = $Camera3D




func _process(delta: float) -> void:
	# DEBUG: Turns off edge panning since it doesn't work with fullscreen/windowed mode switching
	can_edge_pan = false

	# key panning
	# WASD, Arrows
	var pan_axis = Input.get_vector("left", "right", "up", "down")
	self.global_position += Vector3(pan_axis.x, 0.0, pan_axis.y).rotated(Vector3.UP, self.rotation.y) * delta * CAMERA_SPEED

	# edge panning
	if can_edge_pan:
		if get_viewport().get_mouse_position().x <= EDGE_PAN_BORDER:	# left
			self.global_position += Vector3.LEFT.rotated(Vector3.UP, self.rotation.y) * delta * CAMERA_SPEED
		if get_viewport().get_mouse_position().y <= EDGE_PAN_BORDER:	# up
			self.global_position += Vector3.FORWARD.rotated(Vector3.UP, self.rotation.y) * delta * CAMERA_SPEED
		if get_viewport().get_mouse_position().x >= window_width - EDGE_PAN_BORDER:	# right
			self.global_position += Vector3.RIGHT.rotated(Vector3.UP, self.rotation.y) * delta * CAMERA_SPEED
		if get_viewport().get_mouse_position().y >= window_height - EDGE_PAN_BORDER:	# down
			self.global_position += Vector3.BACK.rotated(Vector3.UP, self.rotation.y) * delta * CAMERA_SPEED

	# key rotate
	# Q and E
	if Input.is_action_pressed("q"):
		self.rotate_y(-(ROTATION_SPEED*2*delta))
	if Input.is_action_pressed("e"):
		self.rotate_y((ROTATION_SPEED*2*delta))

	# mouse rotate
	current_mouse_position = get_viewport().get_mouse_position()
	mouse_position_label.text = "Current Mouse Position: "+str(current_mouse_position)
	mouse_delta_label.text = "Delta Mouse Position: "+str(delta_mouse_position)
	if is_rotating_camera:
		self.rotate_y(-(delta_mouse_position.x*delta*ROTATION_SPEED))
	
	# zoom
	# move camera along it's local z-axis (forward)
	if Input.is_action_just_released("scroll_up") and camera.position.z >= MIN_ZOOM:
		camera.position += Vector3.FORWARD.rotated(Vector3.RIGHT, camera.rotation.x) * delta * ZOOM_SPEED
	if Input.is_action_just_released("scroll_down") and camera.position.z <= MAX_ZOOM:
		camera.position -= Vector3.FORWARD.rotated(Vector3.RIGHT, camera.rotation.x) * delta * ZOOM_SPEED


	# reset the delta mouse position at end of frame (so that the camera stops spinning)
	if delta_mouse_position != Vector2.ZERO:
		delta_mouse_position = Vector2.ZERO




func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("fullscreen"):
			set_window_dimensions()

	if event is InputEventMouseButton:
		if event.is_action_pressed("middle_click"):
			is_rotating_camera = true
			can_edge_pan = false
		if event.is_action_released("middle_click"):
			is_rotating_camera = false
			can_edge_pan = true
		if event.is_action_pressed("right_click"):
			can_edge_pan = false
		if event.is_action_released("right_click"):
			can_edge_pan = true

	if event is InputEventMouseMotion:
		if is_rotating_camera:
			delta_mouse_position = event.screen_relative




func raycast_to_floor(origin: Vector3, direction: Vector3, collision_mask: int = 4294967295) -> Dictionary:
	var space_state = get_world_3d().direct_space_state
	var end = direction * 2000
	var query = PhysicsRayQueryParameters3D.create(origin, end, collision_mask)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	return result



func set_window_dimensions() -> void:
	var view_size: Vector2 = get_viewport().size
	window_width = int(view_size.x)
	window_height = int(view_size.y)