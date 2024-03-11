class_name AddLayerContainer extends HBoxContainer

var button_scene: PackedScene = preload("res://scenes/ui_components/add_layer_button.tscn")

@export var layer_container: LayerContainer

var max_layers: int = 5
var current_layers: int = 5


func _ready() -> void:
	max_layers = layer_container.max_layers
	current_layers = layer_container.get_layers().size()
	# for i in range(current_layers):
	# 	layer_container.add_layer()


func add_layer() -> void:
	current_layers = layer_container.get_layers().size()
	if current_layers < max_layers+2:
		layer_container.add_layer()
		current_layers += 1
		update_buttons()


func remove_layer() -> void:
	if current_layers > 2:
		layer_container.remove_layer()
		update_buttons()


func update_buttons() -> void:
	if current_layers == 2:
		get_child(0).hide()
		get_child(1).show()
	elif current_layers == max_layers+2:
		get_child(0).show()
		get_child(1).hide()
	else:
		get_child(0).show()
		get_child(1).show()


func on_layer_removed() -> void:
	current_layers -= 1
	update_buttons()