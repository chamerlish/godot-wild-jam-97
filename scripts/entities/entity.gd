class_name Entity extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

func _process(_delta: float) -> void:
	if !velocity.x == 0:
		sprite.flip_h = velocity.x < 0 
