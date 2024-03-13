extends Control

@onready var layer_container: HBoxContainer = %LayerContainer

var neuron_scene: PackedScene = preload("res://scenes/ui_components/neuron.tscn")



func _ready() -> void:
	layer_container.neuron_scene = neuron_scene
	

