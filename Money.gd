extends Area2D

signal got_money #To make emitted Signal a Signal

func _on_Money_body_entered(body): # Calls when Player collects the money($RichyRich)
	emit_signal("got_money") #Emits the signal to update the Canvas layer or Players HUD (User defined Signal)
#	body.add_money() #The body entered or the collector(Player) should have this func add_money() to call it, Adds the money to Players Script
	queue_free() #Frees or delete the scene form the Main scene 
#	set_collision_mask_bit(0,false) to stop double collect or double take

