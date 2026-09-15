class_name NPC extends Entity

const SPEED = 150.0

var target_direction: Vector2

@export var npc_quest: Quest

func _ready() -> void:
	NPCUtils.interact.connect(interact)
	NPCUtils.pickup.connect(pickup)

func _physics_process(_delta: float) -> void:
	velocity = target_direction.normalized() * SPEED

	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision and not collision.get_collider() is Player: 
		target_direction = generate_random_direction()
		
@onready var running_break_time: Timer = $RunningBreakTime


func generate_random_direction() -> Vector2:
	return Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	)

@onready var dialogue_point: Marker2D = $DialoguePoint

func interact(target: Node2D, held_item: Node2D) -> void:
	if target != self:
		return
	
	var test_array: Array[String] = ["HEy", "baller"]
	
	DialogueManager.start_dialogue.emit(
		test_array, 
		dialogue_point)
	 

func pickup(target: Node2D) -> void:
	if target != self:
		return
	
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_change_direction_delay_timeout(source: Timer) -> void:
	target_direction = Vector2.ZERO
	velocity = Vector2.ZERO
	
	
	running_break_time.start()
	look_around(source)
	await running_break_time.timeout
	source.start()
	
	
	target_direction = generate_random_direction()


@onready var flip_looking_delay: Timer = $FlipLookingDelay

func look_around(delay_timer: Timer) -> void:
	while delay_timer.time_left == 0:
		flip_looking_delay.start()
		await flip_looking_delay.timeout
		sprite.flip_h = !sprite.flip_h
	
