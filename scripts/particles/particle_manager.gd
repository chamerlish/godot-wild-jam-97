extends Node

var confetti_particle: PackedScene = preload("res://scene/particles/quest_finish_confetti.tscn")

func start_particle(start_position: Vector2): 
	var confetti_node: CPUParticles2D = confetti_particle.instantiate()
	
	confetti_node.global_position = start_position
	
