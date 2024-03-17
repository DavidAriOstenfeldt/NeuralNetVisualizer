class_name HalfCirclesData extends ToyData


func generate(samples: int, noise:float, radius: float=1.0):
    var matrix_data: Array[float] = []
    var label_data: Array[float] = []
    for i in samples:
        # Random angle
        var alpha = 2 * PI * randf()

        # Random radius
        var r = radius * sqrt(randf())

        # Calculating x and y
        var x = r * cos(alpha) + randf_range(-noise, noise)
        var y = r * sin(alpha) + randf_range(-noise, noise)

        # Labeling the data
        var label:float  = 0 if y < 0 else 1

        # Append to matrix data
        matrix_data.append_array([x, y])
        label_data.append(label)
    
    data = Matrix.new(samples, 2, matrix_data)
    labels = Matrix.new(samples, 1, label_data)


