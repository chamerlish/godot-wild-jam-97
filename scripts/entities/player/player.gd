class_name Player extends Entity

const MAX_SPEED: float = 250.0
const ACCELERATION: float = 800.0
const FRICTION: float = 600.0


func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction:
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
		

	move_and_slide()
