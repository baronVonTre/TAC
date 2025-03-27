extends Node

var clicked_object_position: Vector3
var clicked_object: Dictionary


func unproject(camera: Camera3D, pos: Vector3) -> Vector2:
    var un_pos = camera.unproject_position(pos)
    return un_pos


func unproject_fov(camera: Camera3D, pos: Vector3) -> Vector2:
    var view_matrix = camera.get_camera_transform().affine_inverse()
    var projection_matrix = camera.get_camera_projection()
    var camera_space_position = view_matrix.xform(pos)
    var clip_space_position = projection_matrix.xform(camera_space_position)

    if clip_space_position.w == 0.0:
        return Vector2()

    var ndc_position = clip_space_position.xyz / clip_space_position.w
    var screen_size = get_viewport().size
    var screen_position = Vector2(
        (ndc_position.x * 0.5 + 0.5) * screen_size.x,
        (1.0 - (ndc_position.y * 0.5 + 0.5)) * screen_size.y
    )

    return screen_position


func get_extents(camera: Camera3D, object: MeshInstance3D):
    var aabb = object.get_aabb()
    var corners = [
        aabb.position,
        aabb.position + Vector3(aabb.size.x, 0, 0),
        aabb.position + Vector3(0, aabb.size.y, 0),
        aabb.position + Vector3(0, 0, aabb.size.z),
        aabb.position + Vector3(aabb.size.x, aabb.size.y, 0),
        aabb.position + Vector3(aabb.size.x, 0, aabb.size.z),
        aabb.position + Vector3(0, aabb.size.y, aabb.size.z),
        aabb.position + aabb.size
    ]

    var min_x = INF
    var max_x = -INF
    var min_y = INF
    var max_y = -INF

    for corner in corners:
        var world_pos = object.global_transform.xform(corner)

        var screen_pos = camera.unproject_position(corner)
        min_x = min(min_x, screen_pos.x)
        max_x = max(max_x, screen_pos.x)
        min_y = min(min_y, screen_pos.y)
        max_y = max(max_y, screen_pos.y)

    return {
        "left": min_x,
        "right": max_x,
        "top": min_y,
        "bottom": max_y
    }
    


func raycast(camera: Camera3D) -> Dictionary:
    var space_state = camera.get_world_3d().direct_space_state
    var mouse_pos = get_viewport().get_mouse_position()
    var origin = camera.project_ray_origin(mouse_pos)
    var end = origin + camera.project_ray_normal(mouse_pos) * 10000
    var query = PhysicsRayQueryParameters3D.create(origin, end)
    query.collide_with_areas = true

    var result = space_state.intersect_ray(query)

    return result