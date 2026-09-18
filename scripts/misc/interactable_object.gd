extends StaticBody2D

@export var related_objective: Objective

func _ready() -> void:
	NPCUtils.interact.connect(_connect_event)
	
func _connect_event(target: Node2D, held_item: Node2D = null) -> void:
	if target != self:
		return
	
	related_objective.associated_event.trigger_event(held_item, related_objective)
