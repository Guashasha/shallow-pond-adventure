extends Node

func info(message: String):
    print("INFO - " + Time.get_datetime_string_from_system() + " - " + message)
    
func error(message: String, err: int):
    push_error("ERROR - " + Time.get_datetime_string_from_system() + " - " + message + ": " + error_string(err))