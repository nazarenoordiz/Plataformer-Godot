extends Node2D

@onready var duration_timer = $DurationTimer

func start_particle(duration):
	duration_timer.wait_time = duration
	duration_timer.start()

func is_running():
	return !duration_timer.is_stopped()
