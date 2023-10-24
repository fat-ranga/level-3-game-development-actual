extends CharacterBody3D

class_name Australian

var health: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	velocity.y = -9.8
	
	move_and_slide()

func damage() -> void:
	pass

func _die() -> void:
	pass
