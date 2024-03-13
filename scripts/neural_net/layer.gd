class_name Layer

var input
var output


func _init() -> void:
    push_error("layer init not implemented")

func forward_propogation(_input, _printing: bool = false):
    push_error("forward_propogation not implemented")

func backward_propogation(_output_error, _learning_rate):
    push_error("backward_propogation not implemented")

func get_type() -> String:
    return "BaseLayer"


