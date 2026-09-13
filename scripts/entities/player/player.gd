class_name Player extends Entity

const MAX_SPEED: float = 250.0
const ACCELERATION: float = 800.0
const FRICTION: float = 600.0

const DROP_OFF_DISTANCE = 20

var picked_up_node: Node2D

var last_direction: Vector2

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		last_direction = direction
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move_and_slide()

@onready var interraction_area: Area2D = $InterractionArea

@onready var picked_up_point: Marker2D = $PickedUpPoint
@onready var drop_off_point: Marker2D = $DropOffPoint

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if picked_up_node:
			drop_off_point.position = last_direction * DROP_OFF_DISTANCE
			picked_up_node.reparent(get_parent())
			picked_up_node.set_transform(drop_off_point.global_transform)
			
			
			picked_up_node.process_mode = Node.PROCESS_MODE_INHERIT
			picked_up_node = null
		else:
			var to_pick_node: Node2D = get_closest_pickable_node()
			if to_pick_node:
				picked_up_node = to_pick_node
				picked_up_node.process_mode = Node.PROCESS_MODE_DISABLED
				picked_up_node.reparent(self)
				picked_up_node.set_transform(picked_up_point.transform)
				to_pick_node = null


func get_closest_pickable_node() -> Node2D:
	var interractable_bodies: Array[Node2D] = interraction_area.get_overlapping_bodies()
	
	var current_closest: Node2D
	var current_closest_distance: float
	
	if not interractable_bodies.is_empty():
		current_closest = interractable_bodies.pick_random()
	
	for body in interractable_bodies:
		if body.is_in_group("Pickable"):
			if global_position.distance_to(body.global_position) < current_closest_distance:
				current_closest = body
	if current_closest.is_in_group("Pickable"):
		return current_closest
	return null
