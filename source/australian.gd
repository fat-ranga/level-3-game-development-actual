extends CharacterBody3D

class_name Australian

var health: int = 100
var max_fire_timer: int = 60
var current_fire_timer: int = max_fire_timer

@export var animation_player: AnimationPlayer
@export var muzzle: Node3D

@onready var projectile_scene = preload("res://scenes/projectiles/bullet.tscn")

# Functionality handled by EnemySpawner.

func damage(amount: int) -> void:
	health -= amount

func fire() -> void:
	ProjectileServer.spawn_projectile(muzzle.global_position, muzzle.global_rotation, projectile_scene)
	
