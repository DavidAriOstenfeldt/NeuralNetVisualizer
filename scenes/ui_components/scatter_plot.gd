extends Control
class_name ScatterPlot

@onready var chart: Chart = $Chart

# This Chart will plot 3 different functions
var f1: Function
var f2: Function

func create_chart(data: Matrix, labels: Matrix, title: String, x_label: String, y_label: String):
	# Let's create our @x values
	# var x: Array = ArrayOperations.multiply_float(range(-10, 11, 1), 0.5)
	
	# And our y values. It can be an n-size array of arrays.
	# NOTE: `x.size() == y.size()` or `x.size() == y[n].size()`
	# var y: Array = ArrayOperations.multiply_int(ArrayOperations.cos(x), 20)
	# var y2: Array = ArrayOperations.add_float(ArrayOperations.multiply_int(ArrayOperations.sin(x), 20), 20)
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#161a1d")
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.WHITE_SMOKE
	cp.draw_bounding_box = false
	cp.title = title
	cp.x_label = x_label
	cp.y_label = y_label
	cp.x_scale = 5
	cp.y_scale = 5
	cp.interactive = true # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot

	var x: Array
	var y: Array

	x = data.get_col(0).data
	y = data.get_col(1).data
	
	var x1: Array = []
	var y1: Array = []
	var x2: Array = []
	var y2: Array = []

	for i in (labels.data.size()):
		if labels.data[i] == 1:
			x2.append(x[i])
			y2.append(y[i])
		else:
			x1.append(x[i])
			y1.append(y[i])

	# Let's add values to our functions
	f1 = Function.new(
		x1, y1, "Class 0", # This will create a function with x and y values taken by the Arrays 
						# we have created previously. This function will also be named "Pressure"
						# as it contains 'pressure' values.
						# If set, the name of a function will be used both in the Legend
						# (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		{ color = Color.GREEN, marker = Function.Marker.CIRCLE }
	)
	f2 = Function.new(x2, y2, "Class 1", { color = Color("#ff6384"), marker = Function.Marker.CROSS })
	
	# Now let's plot our data
	chart.plot([f1, f2], cp)
	
	# Uncommenting this line will show how real time data plotting works
	# set_process(false)


# var new_val: float = 4.5

# func _process(delta: float):
# 	# This function updates the values of a function and then updates the plot
# 	new_val += 5
	
# 	# we can use the `Function.add_point(x, y)` method to update a function
# 	f1.add_point(new_val, cos(new_val) * 20)
# 	f2.add_point(new_val, (sin(new_val) * 20) + 20)
# 	chart.queue_redraw() # This will force the Chart to be updated

