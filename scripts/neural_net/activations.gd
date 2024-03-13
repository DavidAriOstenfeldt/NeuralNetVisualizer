class_name Activation

enum ACTIVATION_FUNCTIONS {TANH = 0,SIGMOID = 1,RELU = 2}


func tanh(x: Matrix): 
	for i in range(x.length()):
		x.data[i] = (exp(x.data[i]) - exp(-x.data[i])) / (exp(x.data[i]) + exp(-x.data[i]))
	return x

func tanh_derivative(x: Matrix): 
	for i in range(x.length()):
		x.data[i] = 1 - (tanh(x.data[i])**2)
	return x

func sigmoid(x: Matrix): 
	for i in range(x.length()):
		x.data[i] = 1 / (1 + exp(-x.data[i]))
	return x

func sigmoid_derivative(x: Matrix): 
    var ones_matrix = Matrix(x.rows, x.cols)
    for i in range(ones_matrix.length()):
        ones_matrix.data[i] = 1
	return sigmoid(x).dot(ones_matrix.subtract(sigmoid(x)))

func ReLU(x: Matrix):
	for i in range(x.length()):
		x.data[i] = max(0, x.data[i])
	return x

func ReLU_derivative(x: Matrix):
    for i in range(x.length()):
        if x.data[i] > 0:
            x.data[i] = 1
        else:
            x.data[i] = 0
    return x
