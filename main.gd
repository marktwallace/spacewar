extends Node

var score

func _ready():
	pass

func _process(delta):
	pass

func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$HUD.show_game_over()

func new_game():
	print("new_game")
	$Music.play()
	score = 0
	$PlayerRight.start($StartPositionRight.position)
	$PlayerLeft.start($StartPositionLeft.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$ScoreTimer.start()
	
