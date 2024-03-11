class_name RemoveLayerButton extends Button

signal remove_layer_pressed


func _ready() -> void:
	remove_layer_pressed.connect(get_parent().remove_layer)

func _on_pressed() -> void:
	remove_layer_pressed.emit()
