extends MeshInstance3D

class_name Projectile

@export var damage: int = 10
var max_lifetime: int = 1000

var current_life_time: int = max_lifetime
var last_position: Vector3 = position
