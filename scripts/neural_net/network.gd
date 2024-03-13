class_name Network

signal epoch_completed()
signal input_completed(outputs: Array[Array])

@export var num_layers: int = 0
var loss: String = "Mean Squared Error"
var layers: Array[Layer] = []
var fc_layers: Array[FCLayer] = []

var losses = LossFunction.new()
var loss_function = null
var loss_derivative = null

func get_layer(layer:int) -> Layer:
	return layers[layer]

func get_weights_in_layer(layer:int) -> Array:
	if layer >= fc_layers.size():
		return fc_layers[fc_layers.size() - 1].get_weights()
	return fc_layers[layer].get_weights()


func get_biases_in_layer(layer:int) -> Array:
	if layer >= fc_layers.size():
		return fc_layers[fc_layers.size() - 1].get_biases()
	return fc_layers[layer].get_biases()


func add_layer(layer: Layer) -> void:
	self.layers.append(layer)
	if layer is FCLayer:
		self.fc_layers.append(layer)
	

func set_loss(loss_type: String = 'Mean Squared Error') -> void:
	if loss_type == "Mean Squared Error":
		loss_function = func (y_true: Matrix, y_pred: Matrix): return losses.mse(y_pred, y_true)
		loss_derivative = func (y_true: Matrix, y_pred: Matrix): return losses.mse_derivative(y_pred, y_true)


func predict(input:Matrix):
	var num_samples: int = input.shape()[0]

	var result_data: Array[float] = []
	for i in range(num_samples):
		var output = input.get_row(i)
		for layer in layers:
			output = layer.forward_propogation(output)
		
		result_data.append(output.data[0])

	var result: Matrix = Matrix.new(1, num_samples, result_data)

	return result


# Training loop
func train(input: Matrix, target: Matrix, epochs: int, learning_rate: float) -> void:
	var num_samples: int = input.shape()[0]
	
	for epoch in range(epochs):
		var epoch_loss: float = 0.0
		for i in range(num_samples):
			var outputs: Array[Array] = []
			# Forward pass
			var output = input.get_row(i)
			for layer in layers:
				output = layer.forward_propogation(output)
				outputs.append(output.data)
			
			var current_loss = loss_function.call(target.get_row(0), output)
			epoch_loss += current_loss
			
			# Backward pass
			var error = loss_derivative.call(target.get_row(0), output)
			var layers_reversed = layers.duplicate(true)
			layers_reversed.reverse()
			for layer in layers_reversed:
				error = layer.backward_propogation(error, learning_rate)
			
			input_completed.emit(outputs)
		
		epoch_completed.emit()
		print("Epoch: ", epoch+1, " Loss: ", epoch_loss / num_samples)
