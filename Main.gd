extends Node
@export var mob_scene: PackedScene
@export var apple: PackedScene
var score
var screen_size = 700
var cell_size=35
var number_cells=screen_size/cell_size
var rng = RandomNumberGenerator.new()
var apple_pos:Vector2
var apple_d
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func game_over():
	$HUD.show()
	$ScoreTimer.stop()
	$Player.over()
	$Music.stop()
	var final_score=score/len($Player.get_body_data())
	final_score=final_score*10
	$HUD.update_score("Score: "+str(final_score))
	$HUD.update_message(" GAME OVER!")
	$gameOver.play()
	$Player.remove_node_child()
	remove_child(apple_d)
	apple_d.queue_free()
	
	
func new_game():
	score = 0
	$Player.start_game()
	$StartTimer.start()
	$ScoreTimer.start()
	$Music.play()
	create_apple()

func _on_score_timer_timeout():
	score += 1



func random_position_apple():
	var x=rng.randi_range(0,number_cells)
	var y=rng.randi_range(0,number_cells)	
	# verify that the cell is not occupied
	var snake_data=$Player.get_body_data()
	var flag=true;
	var listPositions:Array
	for i in range(len(snake_data)):
		var v_x=snake_data[i].x
		var v_y=snake_data[i].y
		if x==v_x:
			listPositions.append(v_y)
			if y==v_y:
				flag=false
	var i=0
	while !flag and i<number_cells:
		y=i
		flag=!(y in listPositions)
		
	if flag:	
		apple_pos.x=x
		apple_pos.y=y
	else:
		random_position_apple()
	


func check_situation():
	var snake=$Player.get_body_data()
	check_eat(snake)
	cheak_hit(snake)
func create_apple():
	apple_d=apple.instantiate()
	random_position_apple()
	add_child(apple_d)
	view_apple()

func check_eat(snake):
	if snake[0]==apple_pos:
		
		$Player.add_last()
		random_position_apple()
		view_apple()
		
func cheak_hit(snake):
	
	var pos_h=snake[0]
	for i in range(len(snake)):
		if(i!=0):
			if pos_h==snake[i]:
				game_over()
	
func view_apple():
	apple_d.position=(apple_pos * cell_size) + Vector2(0, cell_size)
func _on_player_mov():
	check_situation()


func _on_start_button_pressed():
	$HUD.hide()
	new_game()
	
