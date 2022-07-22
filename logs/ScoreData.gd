extends Node

signal score_updated

var score : int = 0 setget set_score

func reset():
	score = 0

func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated",score)
