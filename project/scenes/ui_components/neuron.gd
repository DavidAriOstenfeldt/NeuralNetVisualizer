extends Button
class_name NeuronButton

@onready var base_stylebox: StyleBoxFlat = get_theme_stylebox("normal").duplicate()
@onready var layer_container: LayerContainer = get_parent().get_parent()
@export var is_input_or_output: bool = false

var weight: float = 0.0
var emission_power: float = 0.0
var base_color_rgb: Array = [0, 0.678, 0.71]
var current_color_rgb: Array = base_color_rgb

signal neuron_pressed(neuron: NeuronButton)

func _ready() -> void:
	neuron_pressed.connect(layer_container.on_neuron_pressed)
	set_weight(randf() - 0.5)

func _process(_delta: float) -> void:
	if is_input_or_output:
		return

	emission_power = lerp(emission_power, abs(weight), 0.1)
	current_color_rgb = base_color_rgb.map(func(x): return x * (1.0 + emission_power * 2.0))
	self_modulate = Color(current_color_rgb[0], current_color_rgb[1], current_color_rgb[2], 1.0)


func set_weight(_weight: float) -> void:
	text = str(snappedf(_weight, 0.01))
	weight = _weight
	

func get_weight() -> float:
	return float(text)

func _on_pressed() -> void:
	if is_input_or_output:
		return
	neuron_pressed.emit(self)
	


		
