extends Camera2D

const CAM_FOLLOW_WEIGHT: float = 0.25

@export var player_node: Player

func _physics_process(delta: float) -> void:
	
	var speed: float = max(0.5, player_node.velocity.length() / player_node.MAX_SPEED)
 
	var follow_weight: float = clamp(CAM_FOLLOW_WEIGHT * speed * delta, 0.0, 1.0)
	
	global_position = global_position.lerp(player_node.global_position, follow_weight)
