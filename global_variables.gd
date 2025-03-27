extends Node

var clicked_object_position: Vector3



func unproject(camera: Camera3D, pos: Vector3) -> Vector2:
    var un_pos = camera.unproject_position(pos)
    return un_pos



func raycast(camera: Camera3D) -> Dictionary:
    var space_state = camera.get_world_3d().direct_space_state
    var mouse_pos = get_viewport().get_mouse_position()
    var origin = camera.project_ray_origin(mouse_pos)
    var end = origin + camera.project_ray_normal(mouse_pos) * 10000
    var query = PhysicsRayQueryParameters3D.create(origin, end)
    query.collide_with_areas = true

    var result = space_state.intersect_ray(query)

    return result