extends GutTest

class TestMatrix extends GutTest:
    func test_get_and_set_element():
        var matrix = Matrix.new(2, 2, [0., 1., 2., 3.])
        assert_true(matrix.get_element(0, 0) == 0)
        assert_true(matrix.get_element(0, 1) == 1)
        assert_true(matrix.get_element(1, 0) == 2)
        assert_true(matrix.get_element(1, 1) == 3)

        matrix.set_element(0, 0, 4)
        assert_true(matrix.get_element(0, 0) == 4)
    
    func test_zero_matrix():
        var matrix = Matrix.new(2, 2, [0., 1., 2., 3.])
        var zero_matrix = matrix.zero_matrix(2, 2)
        assert_true(zero_matrix.get_element(0, 0) == 0)
        assert_true(zero_matrix.get_element(0, 1) == 0)
        assert_true(zero_matrix.get_element(1, 0) == 0)
        assert_true(zero_matrix.get_element(1, 1) == 0)
    
    func test_transpose():
        var matrix = Matrix.new(2, 3, [0., 1., 2., 3., 4., 5.])
        var transposed = matrix.transpose()
        assert_true(transposed.get_element(0, 0) == 0)
        assert_true(transposed.get_element(0, 1) == 3)
        assert_true(transposed.get_element(1, 0) == 1)
        assert_true(transposed.get_element(1, 1) == 4)
        assert_true(transposed.get_element(2, 0) == 2)
        assert_true(transposed.get_element(2, 1) == 5)
    
    func test_add_matrix_matrix():
        var a = Matrix.new(2, 2, [0., 1., 2., 3.])
        var b = Matrix.new(2, 2, [4., 5., 6., 7.])
        var c = a.add(b)
        assert_true(c.get_element(0, 0) == 4)
        assert_true(c.get_element(0, 1) == 6)
        assert_true(c.get_element(1, 0) == 8)
        assert_true(c.get_element(1, 1) == 10)
    
    func test_add_matrix_scalar():
        var a = Matrix.new(2, 2, [0., 1., 2., 3.])
        var c = a.add(1)
        assert_true(c.get_element(0, 0) == 1)
        assert_true(c.get_element(0, 1) == 2)
        assert_true(c.get_element(1, 0) == 3)
        assert_true(c.get_element(1, 1) == 4)

    func test_subtract_matrix_matrix():
        var a = Matrix.new(2, 2, [0., 1., 2., 3.])
        var b = Matrix.new(2, 2, [4., 5., 6., 7.])
        var c = a.subtract(b)
        assert_true(c.get_element(0, 0) == -4)
        assert_true(c.get_element(0, 1) == -4)
        assert_true(c.get_element(1, 0) == -4)
        assert_true(c.get_element(1, 1) == -4)
    
    func test_subtract_matrix_scalar():
        var a = Matrix.new(2, 2, [0., 1., 2., 3.])
        var c = a.subtract(1)
        assert_true(c.get_element(0, 0) == -1)
        assert_true(c.get_element(0, 1) == 0)
        assert_true(c.get_element(1, 0) == 1)
        assert_true(c.get_element(1, 1) == 2)
    
    func test_shape():
        var a = Matrix.new(2, 2, [0., 1., 2., 3.])
        assert_true(a.shape() == [2, 2])

    func test_length():
        var a = Matrix.new(2, 2, [0., 1., 2., 3.])
        assert_true(a.length() == 4)
    
    func test_print():
        var a = Matrix.new(2, 2, [0., 1., 2., 3.])
        a.print()
        assert_true(true)

    func test_get_row():
        var a = Matrix.new(2, 2, [0., 1., 2., 3.])
        var row = a.get_row(0)
        assert_true(row.get_element(0, 0) == 0)
        assert_true(row.get_element(0, 1) == 1)
    
    func test_get_col():
        var a = Matrix.new(2, 2, [0., 1., 2., 3.])
        var column = a.get_col(0)
        assert_true(column.get_element(0, 0) == 0)
        assert_true(column.get_element(1, 0) == 2)
    
class TestMatrixDotProduct extends GutTest:
    func test_2x2():
        var data: Array[float] = [1, 2, 3, 4]
        var a = Matrix.new(2, 2, data)
        var b = Matrix.new(2, 2, data)
        var c = a.dot(b)
        assert_true(c.get_element(0, 0) == 7, "Should be 7")
        assert_true(c.get_element(0, 1) == 10, "Should be 10")
        assert_true(c.get_element(1, 0) == 15, "Should be 15")
        assert_true(c.get_element(1, 1) == 22, "Should be 22")

    func test_3x2dot2x3():
        var data: Array[float] = [1, 2, 3, 4, 5, 6]
        var a = Matrix.new(3, 2, data)
        var b = Matrix.new(2, 3, data)
        var c = a.dot(b)
        
        assert_true(c.get_element(0, 0) == 9, "Should be 9")
        assert_true(c.get_element(0, 1) == 12, "Should be 12")
        assert_true(c.get_element(0, 2) == 15, "Should be 15")
        assert_true(c.get_element(1, 0) == 19, "Should be 19")
        assert_true(c.get_element(1, 1) == 26, "Should be 26")
        assert_true(c.get_element(1, 2) == 33, "Should be 33")
        assert_true(c.get_element(2, 0) == 29, "Should be 29")
        assert_true(c.get_element(2, 1) == 40, "Should be 40")
        assert_true(c.get_element(2, 2) == 51, "Should be 51")

    func test_2x3dot3x2():
        var data: Array[float] = [1, 2, 3, 4, 5, 6]
        var a = Matrix.new(2, 3, data)
        var b = Matrix.new(3, 2, data)
        var c = a.dot(b)
        assert_true(c.get_element(0, 0) == 22, "Should be 22")
        assert_true(c.get_element(0, 1) == 28, "Should be 28")
        assert_true(c.get_element(1, 0) == 49, "Should be 49")
        assert_true(c.get_element(1, 1) == 64, "Should be 64")
    
    func test_1x3dot3x1():
        var data: Array[float] = [1, 2, 3]
        var a = Matrix.new(1, 3, data)
        var b = Matrix.new(3, 1, data)
        var c = a.dot(b)
        assert_true(c == 14, "Should be 14")

    func test_3x1dot1x3():
        var data: Array[float] = [1, 2, 3]
        var a = Matrix.new(3, 1, data)
        var b = Matrix.new(1, 3, data)
        var c = a.dot(b)
        
        assert_true(c.shape() == [3, 3], "Should be [3, 3]")
        assert_true(c.get_element(0, 0) == 1, "Should be 1")
        assert_true(c.get_element(0, 1) == 2, "Should be 2")
        assert_true(c.get_element(0, 2) == 3, "Should be 3")
        assert_true(c.get_element(1, 0) == 2, "Should be 2")
        assert_true(c.get_element(1, 1) == 4, "Should be 4")
        assert_true(c.get_element(1, 2) == 6, "Should be 6")
        assert_true(c.get_element(2, 0) == 3, "Should be 3")
        assert_true(c.get_element(2, 1) == 6, "Should be 6")
        assert_true(c.get_element(2, 2) == 9, "Should be 9")


    func test_1x3dot1x3():
        var data: Array[float] = [1, 2, 3]
        var a = Matrix.new(1, 3, data)
        var b = Matrix.new(1, 3, data)
        var c = a.dot(b)
        assert_true(c == 14, "Should be 14")



