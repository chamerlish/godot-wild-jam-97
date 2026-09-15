extends Control

const TEXT_SPEED: float = 0.06

var lines_to_read: Array[String]
var current_line: int

var is_reading_line: bool

@onready var label: RichTextLabel = $BubblePosition/PanelContainer/MarginContainer/Label
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
	
	if is_showing:
		return
	
	is_showing = true
	current_line = 0
	bubble_position.global_position = tip_position.global_position
	reparent(tip_position)
	lines_to_read = new_lines_to_read

	read_line(current_line, new_lines_to_read)

func read_line(new_line: int, new_lines_to_read: Array[String]) -> void:
	var full_text: String = new_lines_to_read[new_line]
	full_text = full_text.replace("\\n", "\n")
	label.text = ""
	
	is_reading_line = true
	

	var tween: Tween = create_tween()
	

	for i in range(full_text.length()):
		tween.tween_callback(
			func():
				if label.text == full_text: 
					return
				label.text = full_text.substr(0, i + 1)
		).set_delay(TEXT_SPEED)

	tween.tween_callback(_on_line_finished)

@onready var next_line_delay: Timer = $NextLineDelay

func _on_line_finished():
	is_reading_line = false
	
	next_line_delay.stop()
	next_line_delay.start()
	await next_line_delay.timeout
	try_to_read_next_line()

func try_to_read_next_line() -> void:
	if current_line < lines_to_read.size() - 1:
		current_line += 1
		read_line(current_line, lines_to_read)
	else:
		DialogueManager.end_fialogue.emit()
		is_showing = false
		pass

func _input(event: InputEvent) -> void:
	if not is_showing:
		return
	if event.is_action_pressed("ui_accept"):
		if is_reading_line:
			label.text = lines_to_read[current_line]
