extends Node3D

const GRAVITY: float = -14.0
const SPEED: float = 100.0
const JUMP_VELOCITY: float = 9.0

var enemies_to_spawn: int = 20
var enemies: Array[Australian] = []

@onready var australian_scene = preload("res://scenes/australian.tscn")
@export var player: Player

func _ready() -> void:
	_spawn_enemies()

func _physics_process(delta: float) -> void:
	_update_enemies(delta)

func _spawn_enemies() -> void:
	for i in range(enemies_to_spawn):
		var new_australian: Australian = australian_scene.instantiate()
		new_australian.position.y = 200
		new_australian.position.x = randi_range(-50, 50)
		new_australian.position.z = randi_range(-50, 50)
		enemies.append(new_australian)
		
		add_child(new_australian)

func _update_enemies(delta: float) -> void:
	for i in range(enemies.size()):
		if enemies[i].health < 1:
			enemies[i].animation_player.play("die")
		else:
			enemies[i].animation_player.play("walk_idle_ak")
		
		enemies[i].current_fire_timer -= 1
		
		if enemies[i].current_fire_timer < 1:
			enemies[i].fire()
			enemies[i].current_fire_timer = enemies[i].max_fire_timer
			
		
		enemies[i].look_at(player.position + -enemies[i].basis.z)
		enemies[i].rotation.x = 0
		enemies[i].rotation.z = 0
		enemies[i].velocity.x = -enemies[i].basis.z.x * delta * SPEED
		enemies[i].velocity.z = -enemies[i].basis.z.z * delta * SPEED
		
		
		if not enemies[i].is_on_floor():
			enemies[i].velocity.y += GRAVITY * delta * 2
		else:
			if enemies[i].is_on_wall():
				enemies[i].velocity.y = JUMP_VELOCITY
			else:
				enemies[i].velocity.y = -0.2
		
		

		enemies[i].move_and_slide()
