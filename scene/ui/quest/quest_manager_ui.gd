extends CanvasLayer

var quest_ui_label: PackedScene = preload("res://scene/ui/quest/quest_ui_label.tscn")

@onready var quest_list: VBoxContainer = $Control/SideBar/PanelContainer/MarginContainer/QuestList
@onready var quest: Quest = $Quest
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_oppened: bool = false

signal list_animation_started

func _ready() -> void:
	QuestManager.quest_added.connect(_add_quest)
	
	QuestManager.add_quest(quest)


func _add_quest(new_quest: Quest) -> void:
	var quest_node: QuestUILabel = quest_ui_label.instantiate()
	
	quest_node.assign_quest(new_quest)
	
	animation_player.play("new_quest")
	
	quest_list.add_child(quest_node)
	
	await list_animation_started
	quest_node.start_list_animation()

func start_list_animation():
	list_animation_started.emit()
@onready var automatic_close_timer: Timer = $AutomaticCloseTimer

func _input(event: InputEvent) -> void:
	if animation_player.is_playing():
			return
	if event.is_action_pressed("toggle_quest_tab"):
		if is_oppened:
			close_tab()
		else:
			open_tab()
		
		is_oppened = !is_oppened

func close_tab():
	animation_player.play("close_tab")

func open_tab():
	animation_player.play("open_tab")
	automatic_close_timer.start()
	await automatic_close_timer.timeout
	close_tab()
