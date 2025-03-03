@tool
extends BTAction

# Task parameters.
@export var parameter1: float
@export var parameter2: Vector2

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.


# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "MyTask"


# Called to initialize the task.
func _setup() -> void:
	pass


# Called when the task is entered.
func _enter() -> void:
	pass


# Called when the task is exited.
func _exit() -> void:
	pass


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	return SUCCESS


# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
