class_name Event extends Node

@export var associated_objective: Objective


func complete_event() -> void: 
	NPCUtils.finish_event.emit(associated_objective)
