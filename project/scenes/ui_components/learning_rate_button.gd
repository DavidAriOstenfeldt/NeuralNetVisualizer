class_name LearningRateButton extends OptionButton

signal learning_rate_selected(learning_rate: float)


func _on_item_selected(index:int) -> void:
    learning_rate_selected.emit(get_item_text(index).to_float())


func get_learning_rate() -> float:
    return get_item_text(get_selected_id()).to_float()
