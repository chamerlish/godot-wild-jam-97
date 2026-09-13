extends Entity

const SPEED = 150.0

var target_direction: Vector2

func _physics_process(_delta: float) -> void:
	velocity = target_direction.normalized() * SPEED

	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision and not collision.get_collider() is Player: 
		target_direction = generate_random_direction()
		print("h")
		
@onready var running_break_time: Timer = $RunningBreakTime
@onready var flip_looking_delay: Timer = $FlipLookingDelay


func generate_random_direction() -> Vector2:
	return Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	)


func _on_change_direction_delay_timeout(source: Timer) -> void:
	target_direction = Vector2.ZERO
	velocity = Vector2.ZERO
	
	
	running_break_time.start()
	look_around(source)
	await running_break_time.timeout
	source.start()
	
	
	target_direction = generate_random_direction()

func look_around(delay_timer: Timer) -> void:
	while delay_timer.time_left == 0:
		flip_looking_delay.start()
		sprite.flip_h = !sprite.flip_h
		await flip_looking_delay.timeout
	
