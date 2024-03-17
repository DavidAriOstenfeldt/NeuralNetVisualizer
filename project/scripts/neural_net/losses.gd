class_name LossFunction

func mse(y_pred: Matrix, y_true: Matrix):
	var y_pow = y_true.subtract(y_pred).pow(2)
	return y_pow.mean()

func mse_derivative(y_pred: Matrix, y_true: Matrix):
	var subtracted = y_pred.subtract(y_true)
	return subtracted.multiply_by_scalar(2).divide_by_scalar(y_true.length())

	
