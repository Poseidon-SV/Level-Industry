extends Area2D

signal got_EnrG_Ball

func _on_EnrG_Ball_body_entered(body):
	emit_signal("got_EnrG_Ball")
	body.add_EnergyBall()
	queue_free()
