class_name ActivationButton extends OptionButton

signal activation_function_selected(activation_function:String)



func _on_item_selected(index:int) -> void:
    activation_function_selected.emit(get_item_text(index))


func get_activation_function() -> String:
    return get_item_text(get_selected_id())
