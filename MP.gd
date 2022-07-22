extends Node2D

const Idle_duration = 1.0 #To set the travel time of the object(Basically it's Use to change the direction in (given)time 

export var move_to = Vector2.RIGHT * 115 #To set the movment direction(Linear)
export var speed = 7.0 

var follow = Vector2.ZERO #To make gradual change in speed for stoping and starting the object

onready var platform = $KinematicBody2D
onready var tween = $Tween #Main Node for moving platform side to side

func _ready(): #This function is called 1st whenever this program runs 
	_init_tween() #Main function for platforms movment
 
func _init_tween(): #Calls the Tween Node
	var duration = move_to.length() / float(speed * 16) #To set the overall duration of the platform for one side or direction 
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, Idle_duration) #Func for the First half of the whole duration 
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration * Idle_duration * 2 + 1) #Func for the Second half the whole duration
#	tween.interpolate_property(platform, "position", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, Idle_duration) #Same as 1st but with instant speed change
#	tween.interpolate_property(platform, "position", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration * Idle_duration * 2) Same as 2nd bur with instant speed change
	tween.start() #Have to learn more about TWEENS
	
func _physics_process(_delta): #Calls the pyhsics process which contains Follow to make the ride linearlly SMOOOTH
	platform.position = platform.position.linear_interpolate(follow, 0.095)
