class_name FCLayer extends Layer

var input_size: int = 0
var output_size: int = 0

var weights: Matrix
var biases: Matrix

func _init(_input_size:int, _output_size:int, _weights=[]) -> void:
	input_size = _input_size
	output_size = _output_size

	# Initialize the weights and biases
	# TODO: Smarter initialization - maybe parameterize the initialization
	var weight_data: Array[float] = []
	var bias_data: Array[float] = []
	if _weights.size() == 0:
		for i in range(input_size * output_size):
			weight_data.append(randf() - 0.5)
	else:
		if _weights.size() != input_size * output_size:
			push_error("Error: The size of the weights array does not match the input and output size")
			return
		weight_data = _weights
	
	for i in range(output_size):
		bias_data.append(randf() - 0.5)

	weights = Matrix.new(_input_size, _output_size, weight_data)
	biases = Matrix.new(1, _output_size, bias_data)


func get_weights() -> Array:
	return weights.data

func get_bias() -> Array:
	return biases.data

func forward_propogation(input_data: Matrix, printing: bool = false):
	# Calculate the output of the layer, given the input
	input = input_data
	var mul_result = input.dot(weights) # Take the dot product of the input and the weights
	output = biases.add(mul_result) # Add the biases to the result
	
	if printing:
		print("Input: ", input.data)
		print("Shape", input.shape())
		print("Weights: ", weights.data)
		print("Shape", weights.shape())
		print("Biases: ", biases.data)
		print("Shape", biases.shape())
		print("Output: ", output.data)
		print("Shape", output.shape())

	return output

func backward_propogation(output_error, learning_rate):
	# Computes dE/dW and dE/dB for given output_error dE/dY
	# Returns dE/dX (input_error)
	var input_error = output_error.dot(weights.transpose()) # dE/dX = dE/dY * W^T
	var weights_error = input.transpose().dot(output_error) # dE/dW = X^T * dE/dY

	# Update parameters
	weights = weights.subtract(weights_error.multiply_by_scalar(learning_rate))
	biases = biases.subtract(output_error.multiply_by_scalar(learning_rate))

	return input_error


func get_type() -> String:
	return "FCLayer"