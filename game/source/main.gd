extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var s: Summator = Summator.new()
	s.add(7)
	s.add(2.99)
	print(s.get_total())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	