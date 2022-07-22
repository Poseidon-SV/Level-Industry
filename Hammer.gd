extends Area2D

var damage : int = 100

func _on_Hammer_body_entered(body): #Calls when the Player Got crushed by the hammer or the Hydrolic press
	 #Player is dead once it gets caught in the Hydrolic press(ZERO Health)
	body.got_hurt(damage)
