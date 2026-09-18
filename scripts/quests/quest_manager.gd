extends Node

var _current_quests: Array[Quest]

var _completed_quests: Array[Quest]

signal quest_added(new_quest: Quest)
signal quest_completed(associated_quest: Quest)
signal objective_completed(associated_objective: Objective)
signal event_completed(associated_event: Event)


func add_quest(new_quest: Quest) -> void:
	_current_quests.append(new_quest)
	quest_added.emit(new_quest)


func is_in_list(to_check_quest: Quest) -> bool:
	return _current_quests.has(to_check_quest)


func finish_quest(updated_quest: Quest) -> void:
	if not _completed_quests.has(updated_quest):
		quest_completed.emit(updated_quest)
		_completed_quests.append(updated_quest)


func update_quest(updated_quest: Quest) -> void:
	if not is_in_list(updated_quest):
		return
		#if can_add_quest:
		#	add_quest(updated_quest)
		#else:
		#	return
	
	if updated_quest.completed:
		finish_quest(updated_quest)
