
class_name Quest extends Node

@export var quest_name: StringName
@export var objective_list: Array[Objective]

var completed: bool = false

var current_step: int = 0:
	set(value):
		current_step = value

@onready var current_objective: Objective:
	get:
		return objective_list.get(current_step)


func _ready() -> void:
	QuestManager.objective_completed.connect(_on_finished_objective)


func _on_finished_objective(associated_objective: Objective) -> void:
	if associated_objective != current_objective:
		return
	
	finish_step()


func check_result(held_item: Node2D) -> Array:
	var result: Array = await current_objective.check_result(held_item)
	
	if result[0]:
		QuestManager.objective_completed.emit(current_objective)
	
	return result


func finish_step() -> void:
	current_objective.complete_callback()
	current_step += 1
	
	if current_step >= objective_list.size():
		completed = true
		QuestManager.finish_quest(self)


func finish_specific_step(step: int) -> void:
	if step == current_step:
		finish_step()


func get_objective(step: int) -> Objective:
	return objective_list.get(step)
