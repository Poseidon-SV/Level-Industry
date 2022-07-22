extends CanvasLayer #HUD
#Nothing to explain(NOTE/COMMENT)
var money = 0
var EnergyBall = 0
var health = 100

onready var health_b = $HealthBarB
onready var Htween = $HealthTween

func _ready():
	if money < 10:
		$Money_Label.text = "0" + String(money)
	else:
		$Money_Label.text = String(money)
	
	if EnergyBall < 10:
		$EnergyBall_Label.text = "0" + String(EnergyBall)
	else:
		$EnergyBall_Label.text = String(EnergyBall)
		
		
func _process(delta):
	$HealthBarF.value = health
	
func _on_Money_got_money():
	money = money + 1
	$money.play()
	_ready()
	ScoreData.score += 1

func _on_Player_got_EnergyBall():
	EnergyBall = EnergyBall + 8
	$Eball.play()
	_ready()
	ScoreData.score += 6
func _on_Player_used_an_EnergyBall():
	EnergyBall = EnergyBall - 1
	_ready()
	ScoreData.score -= 1

func _on_HealthBarF_value_changed(value):
	Htween.interpolate_property(health_b, "value", health_b.value, health, 0.9, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0)
	Htween.start()
