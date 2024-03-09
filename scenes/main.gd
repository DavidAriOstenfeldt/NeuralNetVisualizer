extends Control

# @export var network: XORNetwork

# @onready var num_layers: int = network.num_layers
# @onready var num_neurons: Array[int] = network.neurons
@onready var layer_container: HBoxContainer = %LayerContainer

var neuron_scene: PackedScene = preload("res://scenes/ui_components/neuron.tscn")
# var ghost_neuron_scene: PackedScene = preload("res://scenes/ui_components/ghost_neuron.tscn")
# var activation_functions: Array = []
# var layers: Array = []


func _ready() -> void:
	layer_container.neuron_scene = neuron_scene
	# for act in network.activation_functions:
	# 	activation_functions.append(act)
	# visualize_network()


# func create_neuron(layer: int, weight: float, is_input_or_output: bool = false) -> void:
# 	var neuron = neuron_scene.instantiate()
# 	layers[layer].add_child(neuron)
# 	neuron.neuron_pressed.connect(layer_container.on_neuron_pressed)
# 	neuron.layer = layer
# 	neuron.layer_container = layer_container
# 	neuron.set_weight(weight)
# 	neuron.is_input_or_output = is_input_or_output


# func visualize_network() -> void:
# 	# Visualize the input layer
# 	var input_layer = VBoxContainer.new()
# 	layer_container.add_child(input_layer)
# 	layers.append(input_layer)
# 	var inputs: Array = network.get_weights_in_layer(0)
# 	for i in range(inputs.size()):
# 		create_neuron(0, inputs[i], true)
# 	input_layer.alignment = input_layer.ALIGNMENT_CENTER
# 	input_layer.add_theme_constant_override("separation", 10)

# 	# Visualize Hidden Layers
# 	for i in range(num_layers):
# 		var layer = VBoxContainer.new()
# 		layer_container.add_child(layer)
# 		layers.append(layer)
# 		var weights = network.get_weights_in_layer(i)
# 		for n in range(num_neurons[i]):
# 			create_neuron(i+1, weights[n])
# 		var ghost_neuron: GhostNeuronButton = ghost_neuron_scene.instantiate()
# 		layer.add_child(ghost_neuron)
# 		ghost_neuron.neuron_pressed.connect(layer_container.on_ghost_neuron_pressed)
# 		layer.alignment = layer.ALIGNMENT_CENTER
# 		layer.add_theme_constant_override("separation", 10)
		
	
# 	# Visualize Output Layer
# 	var output_layer = VBoxContainer.new()
# 	layer_container.add_child(output_layer)
# 	layers.append(output_layer)
# 	var outputs: Array = network.get_weights_in_layer(network.get_layers().size() - 1)
# 	for i in range(outputs.size()):
# 		create_neuron(num_layers+1, outputs[i], true)
# 	output_layer.alignment = output_layer.ALIGNMENT_CENTER
# 	output_layer.add_theme_constant_override("separation", 10)

# 	layer_container.draw_lines = true

