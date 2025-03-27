extends Node3D

@export var camera: Camera3D

signal indicate_position(pos: Vector2)


func _ready() -> void:
    pass



func _input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.is_action_released("F1"):
            get_tree().quit()

    if event is InputEventMouseButton:
        if event.is_action_released("lmb"):
            var rayhit = GlobalVariables.raycast(camera)
            if rayhit:
                GlobalVariables.clicked_object_position = rayhit.collider.global_position
                indicate_position.emit(rayhit.collider.global_position)