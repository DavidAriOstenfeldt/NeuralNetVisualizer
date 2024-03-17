class_name FCNetwork extends Node

# Printing
@export var printing: bool = false

# Get references
@export var stop_layer: PanelContainer
@export var layer_container: LayerContainer
@export var learning_rate_button: LearningRateButton
@export var epochs_button: EpochsButton
@export var activation_function_button: ActivationButton
@export var train_button: TrainButton
@export var train_progress_bar: ProgressBar
@export var epoch_label: Label

@onready var scattter_plot: ScatterPlot = %ScatterPlot
@onready var data_set_option_button: OptionButton = %DataSetOptionButton
@onready var samples_spin_box: SpinBox = %SamplesSpinBox
@onready var noise_slider: HSlider = %NoiseSlider

# Training data
var data: ToyData
var train_data: Array[float] = [0., 0., 0., 1., 1., 0., 1., 1.]
var x_train: Matrix = Matrix.new(4, 2, train_data)
var label_data: Array[float] = [0., 0., 1., 1.]
var y_train: Matrix = Matrix.new(4, 1, label_data)

# Network parameters
var net: Network
var loss = 'Mean Squared Error'
var learning_rate: float = 0.1
var epochs: int = 1
var num_neurons_in_layer: Array[int] = []
var num_layers: int = 0
var layers: Array = []
var neurons: Array[Array] = []
var activation_function: String = ''
var act_func: Activation.ACTIVATION_FUNCTIONS

var buttons_to_enable: Array = []

func _ready() -> void:
	# Safety checks
	if stop_layer == null:
		push_error("Stop layer not found")
		return

	if layer_container == null:
		push_error("Layer container not found")
		return
	
	if learning_rate_button == null:
		push_error("Learning rate button not found")
		return
	
	if epochs_button == null:
		push_error("Epochs button not found")
		return
	
	if activation_function_button == null:
		push_error("Activation function button not found")
		return
	
	if train_button == null:
		push_error("Train button not found")
		return
	
	if train_progress_bar == null:
		push_error("Train progress bar not found")
		return
	
	# Connect signals
	train_button.train_button_pressed.connect(train_network)

	# Setup network
	setup_network()


func setup_network():
	# Clear previous network
	epochs = 1
	learning_rate = 0.1
	num_neurons_in_layer.clear()
	neurons.clear()
	layers.clear()
	num_layers = 0
	loss = 'Mean Squared Error'
	activation_function = ''
	train_progress_bar.set_value(0)
	epoch_label.text = "Epoch: 0 Loss: 0.0"
	

	# Get parameters
	learning_rate = learning_rate_button.get_learning_rate()
	epochs = epochs_button.get_epochs()
	layers = layer_container.get_layers()
	num_layers = layers.size()
	activation_function = activation_function_button.get_activation_function().to_lower()
	train_progress_bar.set_max(epochs)
	match activation_function:
		'sigmoid':
			act_func = Activation.ACTIVATION_FUNCTIONS.SIGMOID
		'relu':
			act_func = Activation.ACTIVATION_FUNCTIONS.RELU
		'tanh':
			act_func = Activation.ACTIVATION_FUNCTIONS.TANH

	# Get neurons in each layer
	for layer in layers:
		var _neurons = layer_container.get_neurons_in_layer(layer)
		neurons.append(_neurons)
		num_neurons_in_layer.append(_neurons.size())
	
	
	# Print parameters
	if printing:
		print("Learning rate: ", learning_rate)
		print("Epochs: ", epochs)
		print("Activation function: ", activation_function)
		print("Layers: ", num_layers)
		print("Neurons: ", num_neurons_in_layer)
		print("Layer objects: ", layers)
		print("Neuron objects: ", neurons)

	net = Network.new()

	# Add layers and activation functions
	# Input layer
	if printing:
		print("Input: ", num_neurons_in_layer[0], " -> ", num_neurons_in_layer[1])
	net.add_layer(FCLayer.new(num_neurons_in_layer[0], num_neurons_in_layer[1]))

	# Hidden and Output Layer
	for i in range(num_layers-2): # skipping input and output layers
		if printing:
			print("FC ", i, ": ", num_neurons_in_layer[i+1], " -> ", num_neurons_in_layer[i+2])
			
		net.add_layer(FCLayer.new(num_neurons_in_layer[i+1], num_neurons_in_layer[i+2]))
		if i < num_layers-3:
			if printing:
				print("Activation: ", activation_function)
			net.add_layer(ActivationLayer.new(act_func))
		else: # Output layer activation
			if printing:
				print("Activation: ", "sigmoid")
			net.add_layer(ActivationLayer.new(Activation.ACTIVATION_FUNCTIONS.SIGMOID))

	net.input_completed.connect(layer_container.input_completed)
	net.training_completed.connect(training_completed)
	net.epoch_completed.connect(epoch_completed)

func get_layers():
	return net.layers

func get_layer(layer: int):
	return net.get_layer(layer)

func get_weights_in_layer(layer: int):
	return net.get_weights_in_layer(layer)

func train_network():
	set_mouse_filter()
	setup_network()
	net.set_loss(loss)
	net.train(x_train, y_train, epochs, learning_rate)

func epoch_completed(epoch: int, _loss: float, _outputs:Array[Array]):
	call_deferred_thread_group("update_progress", epoch, _loss)

func update_progress(epoch: int, _loss: float):
	train_progress_bar.set_value(epoch)
	epoch_label.text = "Epoch: " + str(epoch) + " Loss: " + str(_loss)

func training_completed():
	call_deferred_thread_group("set_mouse_filter")

func set_mouse_filter():
	if stop_layer.mouse_filter == Control.MOUSE_FILTER_IGNORE:
		stop_layer.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		stop_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE

func test_network():
	var out = net.predict(x_train)
	out.print()
 
func create_data(data_type: String, samples: int, noise: float):
	if data_type == 'Half Circles':
		data = HalfCirclesData.new()
		data.generate(samples, noise)

	scattter_plot.create_chart(data.data, data.labels, data_type, "X", "Y")

	# Training data
	train_data = data.data.data
	x_train = Matrix.new(samples, 2, train_data)
	label_data = data.labels.data
	y_train = Matrix.new(samples, 1, label_data)

func _on_generate_data_button_pressed() -> void:
	var data_type = data_set_option_button.get_item_text(data_set_option_button.get_selected())
	var samples = samples_spin_box.get_value()
	var noise = noise_slider.get_value()
	create_data(data_type, samples, noise)
