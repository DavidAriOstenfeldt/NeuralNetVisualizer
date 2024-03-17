class_name ToyData extends Resource

@export var name: String = "BaseToyData"
@export var description: String = "A toy dataset for testing purposes"

var data: Matrix
var labels: Matrix

func generate(samples: int, noise: float):
    push_error(name + " does not implement generate()")

func get_samples(batch_size: int, shuffle: bool = true):
    push_error(name + " does not implement get_samples()")
    


