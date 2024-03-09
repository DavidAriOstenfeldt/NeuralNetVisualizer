extends Button
class_name NeuronButton

@onready var layer_container: LayerContainer = get_parent().get_parent()
@export var is_input_or_output: bool = false

signal neuron_pressed(neuron: NeuronButton)

func _ready() -> void:
	neuron_pressed.connect(layer_container.on_neuron_pressed)
	set_weight(randf() - 0.5)

func set_weight(weight: float) -> void:
	text = str(snappedf(weight, 0.01))

func _on_pressed() -> void:
	if is_input_or_output:
		return
	neuron_pressed.emit(self)
	
		
