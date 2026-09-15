class_name Objective extends Node


var completed: bool = false:
	set(value):
		if value:
			complete_callback()
		completed = value

@export var object_needed: Node2D 
@export var description: String
@export var normal_message: Array[String]
@export var success_message: Array[String]

func complete_callback() -> void:
	pass
