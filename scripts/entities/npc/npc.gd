class_name NPC extends Entity

const SPEED = 150.0

var target_direction: Vector2
var is_in_dialogue: bool
var last_intr_succ: bool

@export var npc_quest: Quest

var is_happy: bool = false

@onready var running_break_time: Timer = $RunningBreakTime
@onready var dialogue_point: Marker2D = $DialoguePoint
@onready var flip_looking_delay: Timer = $FlipLookingDelay


func _ready() -> void:
	NPCUtils.interact.connect(interact)
	NPCUtils.pickup.connect(pickup)
	
	DialogueManager.end_fialogue.connect(_on_end_dialogue)
	
	QuestManager.quest_completed.connect(_on_finished_quest)

func _on_end_dialogue(target: NPC):
	if target != self:
		return
	
	if not QuestManager.is_in_list(npc_quest):
		QuestManager.add_quest(npc_quest)
		return
	
	QuestManager.update_quest(npc_quest)
	is_in_dialogue = false

func _on_finished_quest(associated_quest: Quest) -> void:
	if npc_quest != associated_quest:
		return
	is_happy = true
	print(is_happy)


func _physics_process(_delta: float) -> void:
	if is_in_dialogue or not is_happy:
		return
	
	velocity = target_direction.normalized() * SPEED
	move_and_slide()
	
	var collision = get_last_slide_collision()
	if collision and not collision.get_collider() is Player:
		target_direction = generate_random_direction()


func generate_random_direction() -> Vector2:
	return Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	)


func interact(target: Node2D, held_item: Node2D) -> void:
	if target != self or is_happy:
		
		return
	
	var result: Array = await npc_quest.check_result(held_item)
	last_intr_succ = result[0]
	
	DialogueManager.start_dialogue.emit(
		result[1],
		dialogue_point,
		self
	)
	
	is_in_dialogue = true


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


func look_around(delay_timer: Timer) -> void:
	while delay_timer.time_left == 0 and not is_in_dialogue:
		flip_looking_delay.start()
		await flip_looking_delay.timeout
		sprite.flip_h = !sprite.flip_h
