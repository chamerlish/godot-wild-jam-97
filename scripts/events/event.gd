class_name Event extends Node

@export var associated_quest: Quest
@export var specific_step: int

signal finish_event

func complete_event() -> void: 
	NPCUtils.finish_event.emit(associated_quest)

func trigger_event(held_item: Node2D, associated_objective: Objective) -> void:
	associated_quest.finish_specific_step(specific_step)
	associated_objective.set_response(true)
	finish_event.emit()
