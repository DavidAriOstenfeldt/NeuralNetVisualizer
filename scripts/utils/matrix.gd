class_name Matrix
	
var rows: int
var cols: int
var data: Array[float]

func _init(_rows: int, _cols: int, _data: Array[float]):
	rows = _rows
	cols = _cols
	data = _data

	if data.size() != length():
		push_error("Invalid input for Matrix, data must be of size rows * cols but is ", data.size(), " instead of ", length(), "\nMatrix is of shape: ", shape(), " rows: ", rows, " cols: ", cols, " data: ", data)

func get_row(row: int) -> Matrix:
	if row < 0 or row >= rows:
		push_error("Invalid input for Matrix.get_row, row index out of bounds")
		return null
	
	var _data: Array[float] = []
	for i in range(cols):
		_data.append(data[i + row * cols])
	
	var _matrix: Matrix = zero_matrix(1, cols)
	_matrix.data = _data
	return _matrix

func get_col(col: int) -> Matrix:
	if col < 0 or col >= cols:
		push_error("Invalid input for Matrix.get_col, column index out of bounds")
		return null
	
	var _data: Array[float] = []
	for i in range(rows):
		_data.append(data[col + i * cols])
	
	var _matrix: Matrix = zero_matrix(rows, 1)
	_matrix.data = _data
	return _matrix

func get_element(row: int, col: int) -> float:
	# If the Matrix is not a vector, return the specified element
	var index = col + row * cols
	if index > data.size() - 1:
		push_error("Invalid input for Matrix.get_element, row or column index out of bounds")
		return -1.

	return data[index]

func set_element(row: int, col: int, value: float):
	var index = col + row * cols
	data[index] = value

func shape() -> Array[int]:
	return [rows, cols]

func length() -> int:
	return rows * cols

func print():
	var string = ""
	string += "["
	for i in range(rows):
		if i != 0:
			string += " "
		string += "["
		for j in range(cols):
			string += str(get_element(i, j))
			if j != cols -1:
				string += " "
		string += "]"
		if i != rows - 1:
			string += "\n"
	string += "]"
	print(string)

func transpose() -> Matrix:
	var result_matrix: Matrix = zero_matrix(cols, rows)
	for i in range(rows):
		for j in range(cols):
			result_matrix.set_element(j, i, get_element(i, j))
	return result_matrix

func zero_matrix(_rows:int, _columns:int) -> Matrix:
	var matrix_data: Array[float] = []
	matrix_data.resize(_rows * _columns)
	matrix_data.fill(0.)
	return Matrix.new(_rows, _columns, matrix_data)

func sum() -> float:
	var result = 0.
	for i in range(length()):
		result += data[i]
	return result

func mean() -> float:
	return sum() / length()

func pow(exponent: float) -> Matrix:
	var result_matrix: Matrix = zero_matrix(rows, cols)
	for i in range(rows):
		for j in range(cols):
			result_matrix.set_element(i, j, get_element(i, j)**exponent)
	return result_matrix

func add(other) -> Matrix:
	var result_matrix: Matrix
	
	# Matrix-scalar sum
	if other is float or other is int:
		other = float(other)
		result_matrix = zero_matrix(rows, cols)
		for i in range(rows):
			for j in range(cols):
				result_matrix.set_element(i, j, get_element(i, j) + other)
		return result_matrix
	
	# Matrix-Matrix sum
	if other is not Matrix:
		push_error("Invalid input for Matrix.add, second argument must be a Matrix or a Scalar")
		return null
	
	if rows != other.rows or cols != other.cols:
		push_error("Invalid input for Matrix.add, matrices must have the same dimensions")
		return null

	result_matrix = zero_matrix(rows, cols)
	for i in range(rows):
		for j in range(cols):
			result_matrix.set_element(i, j, get_element(i, j) + other.get_element(i, j))
	return result_matrix

func subtract(other) -> Matrix:
	var result_matrix: Matrix

	# Matrix-scalar subtraction
	if other is float or other is int:
		other = float(other)
		result_matrix = zero_matrix(rows, cols)
		for i in range(rows):
			for j in range(cols):
				result_matrix.set_element(i, j, get_element(i, j) - other)
		return result_matrix
	
	# Matrix-Matrix subtraction
	if other is not Matrix:
		push_error("Invalid input for Matrix.subtract, second argument must be a Matrix or a Scalar")
		return null
	
	if rows != other.rows or cols != other.cols:
		push_error("Invalid input for Matrix.subtract, matrices must have the same dimensions")
		return null
	
	result_matrix = zero_matrix(rows, cols)
	for i in range(rows):
		for j in range(cols):
			result_matrix.set_element(i, j, get_element(i, j) - other.get_element(i, j))
	return result_matrix

func dot(other):
	var result_matrix: Matrix
	# Matrix-scalar product
	if other is float or other is int:
		other = float(other)
		result_matrix = zero_matrix(rows, cols)
		for i in range(rows):
			for j in range(cols):
				result_matrix.set_element(i, j, get_element(i, j) * other)

		return result_matrix
	
	if other is not Matrix:
		push_error("Invalid input for Matrix.dot, second argument must be a scalar or a Matrix")
		return null
	
	# Inner product (both vectors)
	if (rows == 1 or cols == 1) and (other.rows == 1 or other.cols == 1):
		var _length: int = self.length()
		
		# Column-Row vector product (result is a row x other.column matrix)
		if cols == 1 and other.rows == 1:
			result_matrix = zero_matrix(rows, other.cols)
			for i in range(rows):
				for j in range(other.cols):
					result_matrix.set_element(i, j, get_element(i, 0) * other.get_element(0, j))
				
			return result_matrix
		
		if _length != other.length():
			push_error("Invalid input for Matrix.dot, vectors must have the same length")
			return null
		
		var result = 0.
		for i in range(_length):
			result += data[i] * other.data[i]
		
		return result        

	# Matrix-Matrix product
	if cols != other.rows:
		push_error("Invalid input for Matrix.multiply, number of columns in first matrix must be equal to number of rows in second matrix")
		return null

	result_matrix = zero_matrix(rows, other.cols)
	for i in range(rows):
		for j in range(other.cols):
			var _sum = 0.
			for k in range(cols):
				_sum += get_element(i, k) * other.get_element(k, j)
			result_matrix.set_element(i, j, _sum)

	return result_matrix


func divide_by_scalar(scalar: float) -> Matrix:
	if scalar == 0:
		push_error("Invalid input for Matrix.divide_by_scalar, scalar must be different from 0")
		return null

	var result_matrix: Matrix = zero_matrix(rows, cols)
	for i in range(rows):
		for j in range(cols):
			result_matrix.set_element(i, j, get_element(i, j) / scalar)
	return result_matrix

func multiply_by_scalar(scalar: float) -> Matrix:
	var result_matrix: Matrix = zero_matrix(rows, cols)
	for i in range(rows):
		for j in range(cols):
			result_matrix.set_element(i, j, get_element(i, j) * scalar)
	return result_matrix

func elementwise_multiply(other: Matrix) -> Matrix:
	if rows != other.rows or cols != other.cols:
		push_error("Invalid input for Matrix.elementwise_multiply, matrices must have the same dimensions")
		return null

	var result_matrix: Matrix = zero_matrix(rows, cols)
	for i in range(rows):
		for j in range(cols):
			result_matrix.set_element(i, j, get_element(i, j) * other.get_element(i, j))
	return result_matrix

				

