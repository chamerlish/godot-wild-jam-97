extends Control

const TEXT_SPEED: float = 1.5

var lines_to_read: Array[String]
var current_line: int
@onready var label: Label = $BubblePosition/PanelContainer/MarginContainer/Label
@onready var bubble_position: Marker2D = $BubblePosition


var is_showing: bool = false:
	set(value):
		if value:
			show()
		else:
			hide()
		is_showing = value

func _ready() -> void:
	DialogueManager.start_dialogue.connect(start_dialogue)
	NPCUtils.pickup.connect(func(_throwaway: Node2D): is_showing = false)


func start_dialogue(new_lines_to_read: Array[String], tip_position: Marker2D):
	is_showing = true
	current_line = 0
	bubble_position.global_position = tip_position.global_position
	reparent(tip_position)
	lines_to_read = new_lines_to_read

	read_line(current_line, new_lines_to_read)

func read_line(new_line: int, new_lines_to_read: Array[String]) -> void:

	label.visible_ratio = 0.0
	label.text = new_lines_to_read[new_line]

func _process(delta: float) -> void:
	label.visible_ratio = move_toward(label.visible_ratio, 1.0, TEXT_SPEED * delta)

func _input(event: InputEvent) -> void:
	if is_showing == false:
		return
	if event.is_action_pressed("ui_accept"):
		if label.visible_ratio < 1:
			label.visible_ratio = 1
		else:
			if current_line < lines_to_read.size() - 1:
				current_line += 1
				read_line(current_line, lines_to_read)
			else:
				# TODO: send finish signal
				is_showing = false
				pass
