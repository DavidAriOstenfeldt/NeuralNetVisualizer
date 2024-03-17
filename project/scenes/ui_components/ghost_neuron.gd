extends Button
class_name GhostNeuronButton


@onready var layer_container: LayerContainer = get_parent().get_parent()
@export var is_input_or_output: bool = false
var layer: int = 0

signal neuron_pressed(neuron: GhostNeuronButton)

func _ready() -> void:
	neuron_pressed.connect(layer_container.on_ghost_neuron_pressed)

func get_number_of_siblings() -> int:
	return get_parent().get_child_count()

func _on_pressed() -> void:
	if get_number_of_siblings() > layer_container.max_neurons_per_layer:
		return
	neuron_pressed.emit(self)
