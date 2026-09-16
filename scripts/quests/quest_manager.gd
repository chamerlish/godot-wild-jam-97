extends Node

var current_quests: Array[Quest]

signal quest_added(new_quest: Quest)

func add_quest(new_quest: Quest):
	if not new_quest in current_quests:
		current_quests.append(new_quest)
		quest_added.emit(new_quest)


func finish_quest(updated_quest: Quest):
	pass
