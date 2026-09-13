extends CanvasLayer

const TEXT_SPEED: float = 1.5

var lines_to_read: Array[String]
var current_line: int
@onready var label: Label = $PanelContainer/MarginContainer/Label

func _ready() -> void:
	start_dialogue(
		["HELLOOO GIDDAY GIDDYY GIDDAA \n GIDDAA OHHH",
		"i smelly hihihihi",
		"brrrr brrrrrrrrrrrrr"])


func start_dialogue(lines_to_read: Array[String]):
	self.lines_to_read = lines_to_read
	read_line(current_line, lines_to_read)

func read_line(new_line: int, lines_to_read: Array[String]) -> void:
	label.visible_ratio = 0.0
	label.text = lines_to_read[new_line]

func _process(delta: float) -> void:
	label.visible_ratio = move_toward(label.visible_ratio, 1.0, TEXT_SPEED * delta)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print(label.visible_ratio)
		if label.visible_ratio < 1:
			label.visible_ratio = 1
		else:
			if current_line < lines_to_read.size() - 1:
				current_line += 1
				read_line(current_line, lines_to_read)
			else:
				# TODO: send finish signal
				hide()
				pass
