extends Control


func _on_quit_button_pressed():
    get_tree().quit()


func _on_create_game_button_pressed():
    get_tree().change_scene_to_file("res://ui/lobby.tscn")


func _on_join_game_button_pressed():
    get_tree().change_scene_to_file("res://ui/join_server.tscn")
