class_name FCNetwork extends Node

# Printing
@export var printing: bool = false

# Get references
@export var layer_container: LayerContainer
@export var learning_rate_button: LearningRateButton
@export var epochs_button: EpochsButton
@export var activation_function_button: ActivationButton
@export var train_button: TrainButton


# Training data
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

func _ready() -> void:
	# Safety checks
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
	
	# Connect signals
	train_button.train_button_pressed.connect(train_network)

	# Get parameters
	learning_rate = learning_rate_button.get_learning_rate()
	epochs = epochs_button.get_epochs()
	layers = layer_container.get_layers()
	num_layers = layers.size()
	activation_function = activation_function_button.get_activation_function().to_lower()
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

	# Create network
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


func get_layers():
	return net.layers

func get_layer(layer: int):
	return net.get_layer(layer)

func get_weights_in_layer(layer: int):
	return net.get_weights_in_layer(layer)

func train_network():
	net.set_loss(loss)
	net.train(x_train, y_train, epochs, learning_rate)

func test_network():
	var out = net.predict(x_train)
	out.print()
 
