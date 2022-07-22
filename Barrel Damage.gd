extends Area2D 

var damage_area: bool = false #To Make sure that player is in the pit
var damage : int = 5 #Player gets 5 damage as he enters the area and gets knockback

# Not working
#func _process(delta):
#	if damage_area == true:
#		return delta * 0.5 

func _on_Barrel_Damage_body_entered(body):
	body.got_hurt(damage,position.x,100,100)
