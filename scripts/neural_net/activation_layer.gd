class_name ActivationLayer extends Layer

var activations = Activation.new()
var activation_function = activations.ACTIVATION_FUNCTIONS.RELU
var activation = null
var activation_derivative = null

func _init(_activation_function: Activation.ACTIVATION_FUNCTIONS) -> void:
	activation_function = _activation_function
	match activation_function:
		Activation.ACTIVATION_FUNCTIONS.RELU:
			activation = func (x: Matrix) -> Matrix: return activations.ReLU(x)
			activation_derivative = func (x): return activations.ReLU_derivative(x)
		Activation.ACTIVATION_FUNCTIONS.SIGMOID:
			activation = func (x: Matrix) -> Matrix: return activations.sigmoid(x)
			activation_derivative = func (x): return activations.sigmoid_derivative(x)
		Activation.ACTIVATION_FUNCTIONS.TANH:
			activation = func (x: Matrix): return activations.tanh(x)
			activation_derivative = func (x: Matrix): return activations.tanh_derivative(x)

func forward_propogation(input_data: Matrix, printing: bool = false):
	input = input_data
	output = activation.call(input_data)
	if printing:
		print("Activation Layer: ", output.data)
		print("Activation Layer shape: ", output.shape())

	return output

func backward_propogation(output_error: Matrix, _learning_rate):
	return activation_derivative.call(input).elementwise_multiply(output_error)

func get_type() -> String:
	return "ActivationLayer: " + str(activation_function)