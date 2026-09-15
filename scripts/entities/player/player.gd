class_name Player extends Entity

const MAX_SPEED: float = 250.0
const ACCELERATION: float = 800.0
const FRICTION: float = 600.0

const DROP_OFF_DISTANCE = 40

var picked_up_node: Node2D

var last_direction: Vector2

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
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
	if event.is_action_pressed("pickup"):
		if picked_up_node:
			drop_off_point.position = last_direction * DROP_OFF_DISTANCE
			picked_up_node.reparent(get_parent())
			picked_up_node.set_transform(drop_off_point.global_transform)
			
			if picked_up_node is CollisionObject2D:
				picked_up_node.set_collision_layer_value(1, true)
			
			picked_up_node.process_mode = Node.PROCESS_MODE_INHERIT
			picked_up_node = null
		else:
			var to_pick_node: Node2D = get_closest_group_node("Pickable")
			if to_pick_node:
				NPCUtils.pickup.emit(to_pick_node)
				picked_up_node = to_pick_node
				if picked_up_node is CollisionObject2D:
					picked_up_node.set_collision_layer_value(1, false)
				
				picked_up_node.reparent(self)
				picked_up_node.set_transform(picked_up_point.transform)
				to_pick_node = null
	
	if event.is_action_pressed("interact"):
		var to_inter_node: Node2D = get_closest_group_node("Interactable")
		if to_inter_node:
			NPCUtils.interact.emit(to_inter_node, picked_up_node)

func get_closest_group_node(group_name: StringName) -> Node2D:
	var interractable_bodies: Array[Node2D] = interraction_area.get_overlapping_bodies()
	
	var current_closest: Node2D
	var current_closest_distance: float
	
	if not interractable_bodies.is_empty():
		current_closest = interractable_bodies.pick_random()
	
	for body in interractable_bodies:
		if body.is_in_group(group_name):
			if global_position.distance_to(body.global_position) < current_closest_distance or not current_closest.is_in_group(group_name):
				current_closest = body
	if current_closest.is_in_group(group_name):
		return current_closest
	return null
