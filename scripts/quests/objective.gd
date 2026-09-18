class_name Objective extends Node

var return_success: bool
var return_message: Array[String]

@export var associated_event: Event

var completed: bool = false:
	set(value):
		if value:
			complete_callback()
		completed = value

@export var description: String
@export var normal_message: Array[String]
@export var success_message: Array[String]

func complete_callback() -> void:
	pass

func check_result(held_item: Node2D) -> Array:
	if associated_event:
		associated_event.trigger_event(held_item, self)
		await associated_event.finish_event
		QuestManager.event_completed.emit(associated_event)
	return [return_success, return_message]

func set_response(is_success: bool) -> void:
	return_success = is_success
	return_message = success_message if is_success else normal_message
