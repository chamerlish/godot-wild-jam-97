class_name Quest extends Node

@export var quest_name: StringName

var completed: bool = false

signal complete_quest


@export var objective_list: Array[Objective]
var current_step: int = 0
@onready var current_objective: Objective = objective_list[current_step]


func finish_step() -> void:
	current_step += 1
	if current_step >= objective_list.size() - 1:
		completed = true
		complete_quest.emit()
	
	current_objective = objective_list[current_step]
	current_objective.complete_callback()
