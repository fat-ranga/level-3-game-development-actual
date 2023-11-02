extends Node

var projectiles: Array[Projectile] = []

# Because autoloads don't exist in the scene hierarchy to add the bullets.
@onready var world = get_tree().get_current_scene()

func spawn_projectile(position: Vector3, rotation: Vector3, projectile_scene: PackedScene) -> void:
	var projectile: Projectile = projectile_scene.instantiate()
	projectiles.append(projectile)
	world.add_child(projectile)
	projectile.global_position = position
	projectile.global_rotation = rotation
	#projectile.global_rotation += Vector3(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2), randf_range(-0.2, 0.2))

func _physics_process(delta: float) -> void:
	_update_projectiles(delta)

func _update_projectiles(delta) -> void:
	for i in range(projectiles.size()):
		projectiles[i].current_life_time -= 1
		if projectiles[i].current_life_time < 1:
			projectiles[i].queue_free()
			projectiles.remove_at(i)
			return
		projectiles[i].global_position += -projectiles[i].basis.z * delta * 50
		
		# The API for spawning a simple raycast is very bad.
		var space_state: PhysicsDirectSpaceState3D = projectiles[i].get_world_3d().direct_space_state
		var query_parameters = PhysicsRayQueryParameters3D.create(projectiles[i].last_position, projectiles[i].global_position)
		
		var result: Dictionary = space_state.intersect_ray(query_parameters)
		if result:
			var entity = result.collider
			projectiles[i].queue_free()
			projectiles.remove_at(i)
			return
		projectiles[i].last_position = projectiles[i].global_position
