extends Node

var confetti_particle: PackedScene = preload("res://scene/particles/quest_finish_confetti.tscn")

func start_particle(start_position: Vector2):
	var confetti_node: CPUParticles2D = confetti_particle.instantiate()
	
	confetti_node.global_position = start_position
	confetti_node.finished.connect(_on_finished_particle.bind(confetti_node))
	add_child(confetti_node)
	confetti_node.emitting = true
	
func _on_finished_particle(source: CPUParticles2D):
	source.queue_free()
