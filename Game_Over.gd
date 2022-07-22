extends Control

var score : int = 0

func _ready():
	$Node2D/AP_Up.play("UP")
	$Node2D/AP_Down.play("Down")
	score = ScoreData.score
	$Score.text = "SCORE: " + String(score)

func _on_Main_menu_pressed():
	ScoreData.reset()
	$buttonMM.play()


func _on_Play_Again_pressed():
	ScoreData.reset()
	$buttonPA.play()

func _on_button_finished():
	get_tree().change_scene("res://Main_Scene.tscn")


func _on_buttonMM_finished():
	get_tree().change_scene("res://Start_menu.tscn")
