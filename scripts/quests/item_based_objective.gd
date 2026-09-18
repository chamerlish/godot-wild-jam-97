class_name ItemBasedObjective extends Objective

@export var object_needed: Node2D 

func check_result(held_item: Node2D) -> Array:
	var is_correct_item: bool = object_needed == held_item
	set_response(is_correct_item)
	
	if is_correct_item:
		return_message = success_message
		held_item.queue_free()
	return [return_success, return_message]
