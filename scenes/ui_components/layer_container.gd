@tool
extends HBoxContainer
class_name LayerContainer

signal layer_removed

var layer_scene: PackedScene = preload("res://scenes/ui_components/layer.tscn")
var ghost_neuron_scene: PackedScene = preload("res://scenes/ui_components/ghost_neuron.tscn")
var layers: Array = []
var listen_for_notifications: bool = false
var neuron_scene: PackedScene

var neurons: Array[NeuronButton] = []

@export var add_layer_container: AddLayerContainer

@export var max_layers: int = 5
@export var max_neurons_per_layer: int = 7

@export var draw_lines: bool = false:
	get:
		return draw_lines
	set(value):
		draw_lines = value
		activate_draw_connections()

@export var line_width: float = 2:
	get:
		return line_width
	set(value):
		line_width = value
		activate_draw_connections()

@export var line_color: Color = Color("#EEEEEE"):
	get:
		return line_color
	set(value):
		line_color = value
		activate_draw_connections()


func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	draw_lines = true
	await get_tree().create_timer(0.1).timeout
	listen_for_notifications = true
	layer_removed.connect(add_layer_container.on_layer_removed)

func activate_draw_connections():
	if draw_lines:
		layers = get_layers()
		draw_connections()
	else:
		clear_connections()

func draw_connections() -> void:
	clear_connections()
	for i in range(layers.size()):
		for child in layers[i].get_children():
			if child is not NeuronButton and child is not ActivationButton:
				continue
			var child_pos = child.global_position
			if i+1 == layers.size():
				break
			for connection in layers[i+1].get_children():
				if connection is not NeuronButton and connection is not ActivationButton:
					continue
				var connect_pos = connection.global_position
				create_line(child_pos, connect_pos)

func clear_connections() -> void:
	for child in get_children():
		if child is Line2D:
			child.queue_free()

func on_neuron_pressed(neuron: NeuronButton) -> void:
	var l = neuron.get_parent()
	neuron.queue_free()
	await neuron.tree_exited
	var children: int = 0
	var does_ghost_neuron_exist: bool = false
	for child in l.get_children():
		if child is NeuronButton:
			children += 1
		if child is GhostNeuronButton:
			does_ghost_neuron_exist = true

	
	if children < max_neurons_per_layer and not does_ghost_neuron_exist:
		var ghost_neuron: GhostNeuronButton = ghost_neuron_scene.instantiate()
		l.add_child(ghost_neuron)
		ghost_neuron.layer_container = self
		await get_tree().create_timer(0.05).timeout

	if children == 0:
		l.queue_free()
		await l.tree_exited
		layer_removed.emit()

	await get_tree().create_timer(0.05).timeout
	
	activate_draw_connections()

func on_ghost_neuron_pressed(neuron: GhostNeuronButton) -> void:
	var l = neuron.get_parent()
	l.remove_child(neuron)
	create_neuron(l, randf()-0.5, false)
	l.add_child(neuron)
	await get_tree().create_timer(0.05).timeout
	if l.get_child_count() > max_neurons_per_layer:
		l.remove_child(neuron)
		await get_tree().create_timer(0.05).timeout
	
	activate_draw_connections()


func create_neuron(layer: VBoxContainer, _weight: float, is_input_or_output: bool = false):
	var neuron = neuron_scene.instantiate()
	layer.add_child(neuron)
	neuron.is_input_or_output = is_input_or_output
	return neuron


func create_line(start_pos:Vector2, end_pos:Vector2) -> void:
	var neuron_size = layers[0].get_child(0).size.y
	var line = AntialiasedLine2D.new()
	add_child(line)
	line.add_point(line.to_local(start_pos + Vector2.ONE*neuron_size/2))
	line.add_point(line.to_local(end_pos + Vector2.ONE*neuron_size/2))
	line.width = line_width
	line.default_color = line_color

func add_layer() -> void:
	layers = get_layers()
	var num_layers = layers.size()
	if num_layers < max_layers+2:
		var _output_layer = layers[num_layers-1]
		layers.remove_at(num_layers-1)
		remove_child(_output_layer)
		var layer = layer_scene.instantiate()
		add_child(layer)
		layers.append(layer)
		add_child(_output_layer)
		layers.append(_output_layer)
		var ghost_neuron = ghost_neuron_scene.instantiate()
		ghost_neuron.layer_container = self
		layer.add_child(ghost_neuron)
		
		for i in range(2):
			on_ghost_neuron_pressed(ghost_neuron)
	

func remove_layer() -> void:
	layers = get_layers()
	var num_layers = layers.size()
	if num_layers > 2:
		var layer = layers[num_layers-2]
		layers.remove_at(num_layers-2)
		for child in layer.get_children():
			if child is NeuronButton:
				on_neuron_pressed(child)
		

func get_neurons_in_layer(layer: VBoxContainer) -> Array[NeuronButton]:
	var _neurons: Array[NeuronButton] = []
	for child in layer.get_children():
		if child is NeuronButton:
			_neurons.append(child)
	return _neurons

func get_weights_in_layer(layer: VBoxContainer) -> Array:
	var weights = []
	for child in layer.get_children():
		if child is NeuronButton:
			weights.append(child.get_weight())
	return weights

func get_layers() -> Array:
	var _layers = []
	for i in get_child_count():
		var child = get_child(i)
		if child is VBoxContainer:
			_layers.append(child)
	return _layers


func set_weights_in_layer(layer: VBoxContainer, weights: Array) -> void:
	neurons = get_neurons_in_layer(layer)
	for i in range(neurons.size()):
		neurons[i].set_weight(weights[i])


func input_completed(weights: Array[Array]) -> void:
	# layers = call_deferred("get_layers")
	for i in range(layers.size()):
		var layer = layers[i]
		call_deferred_thread_group("set_weights_in_layer", layer, weights[i])

	# activate_draw_connections()
