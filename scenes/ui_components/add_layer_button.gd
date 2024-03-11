class_name AddLayerButton extends Button

signal add_layer_pressed


func _ready() -> void:
	add_layer_pressed.connect(get_parent().add_layer)

func _on_pressed() -> void:
	add_layer_pressed.emit()
