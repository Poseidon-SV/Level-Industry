extends Control

var score : int = 0

func _ready():
	$Node2D/AP_Up.play("UP")
	$Node2D/AP_Down.play("Down")
	score = ScoreData.score
	$Score.text = "YOUR SCORE: " + String(score)

func _on_MainMenu_pressed():
	ScoreData.reset()
	$button.play()

func _on_button_finished():
	get_tree().change_scene("res://Start_menu.tscn")
