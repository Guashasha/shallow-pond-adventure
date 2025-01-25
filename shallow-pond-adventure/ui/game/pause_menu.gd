extends Control



func _on_exit_button_pressed() -> void:
    #Todo: popup si el host sale, el juego se acaba. Regresar al menú principal si se acepta
    self.visible = false

func _on_continue_button_pressed() -> void:
    self.visible = false