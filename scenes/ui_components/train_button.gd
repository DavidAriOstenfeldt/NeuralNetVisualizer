class_name TrainButton extends Button

signal train_button_pressed


func _on_pressed() -> void:
	train_button_pressed.emit()
