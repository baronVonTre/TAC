extends ColorRect


@export var world: Node3D
@export var camera: Camera3D


func _ready() -> void:
    world.indicate_position.connect(_move_indicator)
    self.pivot_offset = self.size/2



func _move_indicator(pos: Vector3) -> void:
    print(pos)
    var un_pos = GlobalVariables.unproject(camera, pos)
    print(un_pos)
    self.global_position = un_pos
