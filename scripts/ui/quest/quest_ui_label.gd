class_name QuestUILabel extends RichTextLabel

func assign_quest(quest: Quest):
	text = quest.quest_name
	visible_ratio = 0.0
	# update description

func start_list_animation():
	var tween: Tween = create_tween()
	
	tween.tween_property(self, "visible_ratio", 1.0, 1)
