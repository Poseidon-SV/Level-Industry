extends Area2D

var is_player_inside : bool = false
var is_operated: bool = false
var full_health : bool = false
signal add_health()
signal is_full_health()

func _ready():
	$AnimatedSprite.play("Screen")

func _input(event):
	if event.is_action_pressed("Intract") and is_player_inside == true and is_operated == false and full_health == false:
		is_operated = true
		$AnimatedSprite.play("ScreenUsed")
		emit_signal("add_health")
		$AudioStreamPlayer.play()

func _on_HealthScreen_body_entered(body):
	is_player_inside = true
	full_health = false
	emit_signal("is_full_health")

func _on_Player_full_health():
	full_health = true

func _on_HealthScreen_body_exited(body):
	is_player_inside = false


