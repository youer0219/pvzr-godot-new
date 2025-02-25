class_name TimedDestroy
extends Timer

enum START_MOMENT {READY,MANUAL}

@export var destroy_node:Node
@export var start_monent:START_MOMENT
@export var seconds:float = 10

func _ready() -> void:
	timeout.connect(_on_timeout)
	if start_monent == START_MOMENT.READY:
		start(seconds)

func start_destroy_time(time:float = -1):
	if time == -1:
		start(seconds)
	else:
		start(time)

func _on_timeout() -> void:
	destroy_node.queue_free()
