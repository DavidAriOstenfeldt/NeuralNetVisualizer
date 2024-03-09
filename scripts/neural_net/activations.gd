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

func sigmoid_derivative(x): 
    return sigmoid(x) * (1 - sigmoid(x))

func ReLU(x: Matrix):
    for i in range(x.length()):
        x.data[i] = max(0, x.data[i])
    return x

func ReLU_derivative(x): 
    var out: float = 0.0
    if x >= 0:
        out = 1
    else:
        out = 0
    return out