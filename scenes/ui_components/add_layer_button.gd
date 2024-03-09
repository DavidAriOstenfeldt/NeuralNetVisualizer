class_name AddLayerButton extends Button

signal add_layer_pressed(button: AddLayerButton)



func _on_pressed() -> void:
	add_layer_pressed.emit(self)
