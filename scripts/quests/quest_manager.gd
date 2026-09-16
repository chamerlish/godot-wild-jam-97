extends Node

var _current_quests: Array[Quest]

signal quest_added(new_quest: Quest)

func add_quest(new_quest: Quest):
	_current_quests.append(new_quest)
	quest_added.emit(new_quest)

func is_in_list(to_check_quest: Quest) -> bool:
	return _current_quests.has(to_check_quest)

func finish_quest(_updated_quest: Quest):
	pass

func update_quest(updated_quest: Quest):
	if not is_in_list(updated_quest):
		add_quest(updated_quest)
	
	var quest_index := _current_quests.find(updated_quest)
	
	if updated_quest.current_objective != _current_quests[quest_index].current_objective:
		pass
