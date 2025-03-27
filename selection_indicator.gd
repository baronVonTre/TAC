extends ColorRect


@export var world: Node3D
@export var camera: Camera3D
@export var object_offset: float = 0.0

func _ready() -> void:
	world.indicate_position.connect(_move_indicator)



func _move_indicator(pos: Vector3, deselect: bool = false) -> void:
	if deselect:
		self.hide()
		return
	
	var ext = GlobalVariables.get_extents(camera, GlobalVariables.clicked_object.collider.find_child("MeshInstance3D"))
	var new_diameter = (ext["right"]-ext["left"])+object_offset
	var un_pos = GlobalVariables.unproject(camera, pos)
	self.size = Vector2(new_diameter, new_diameter)
	self.global_position = un_pos-(self.size/2)
	self.show()
