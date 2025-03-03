@tool
extends BTCondition

# Task parameters.
@export var parameter1: float
@export var parameter2: Vector2


# Called to generate a display name for the task.
func _generate_name() -> String:
	return "MyCondition"

# Called to initialize the task.
func _setup() -> void:
	pass


# Called when the task is entered.
func _enter() -> void:
	pass


# Called when the task is exited.
func _exit() -> void:
	pass


# Called when the task is executed.Just return SUCCESS or FAILED
func _tick(_delta: float) -> Status:
	return SUCCESS


# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
