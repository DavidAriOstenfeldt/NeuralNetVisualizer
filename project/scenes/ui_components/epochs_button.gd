class_name EpochsButton extends OptionButton

signal epochs_selected(epochs: int)


func _on_item_selected(index:int) -> void:
    epochs_selected.emit(get_item_text(index).to_int())


func get_epochs() -> int:
    return get_item_text(get_selected_id()).to_int()
