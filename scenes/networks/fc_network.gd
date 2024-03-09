class_name XORNetwork extends Node

@export var num_layers: int = 0
@export var neurons: Array[int] = []
@export var activation_functions: Array[Activation.ACTIVATION_FUNCTIONS] = []

@export_enum("Mean Squared Error") var loss: String = "Mean Squared Error"

@export var epochs: int = 1000
@export var learning_rate: float = 0.1

# training data
var train_data: Array[float] = [0., 0., 0., 1., 1., 0., 1., 1.]
var x_train: Matrix = Matrix.new(4, 2, train_data)
var label_data: Array[float] = [0., 1., 1., 0.]
var y_train: Matrix = Matrix.new(4, 1, label_data)

var net: Network

func _ready() -> void:
	net = Network.new()

	# Prepare network
	if neurons.size() != num_layers:
		push_error("Number of neurons must be equal to number of layers")
		return

	if activation_functions.size() != num_layers:
		push_error("Number of activation functions must be equal to number of layers")
		return

	# Add layers and activation functions
	# Input layer
	net.add_layer(FCLayer.new(2, neurons[0]))

	# Hidden Layers
	for i in range(num_layers):
		if num_layers-1 > i:
			# print("FC: ", neurons[i], " -> ", neurons[i+1])
			net.add_layer(FCLayer.new(neurons[i], neurons[i+1]))
		if activation_functions.size() > i:
			# print("Activation: ", activation_function[i])
			net.add_layer(ActivationLayer.new(activation_functions[i]))
	
	# Output layer
	net.add_layer(FCLayer.new(neurons[num_layers-1], 1))

	# print("Layers: ", net.layers.size())

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
 
