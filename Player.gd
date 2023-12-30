extends Node

signal mov
@export var speed = 20
@export var body_snake: PackedScene
var  screen_size = 700
var cell_size=35
var number_cells=screen_size/cell_size
var position_init=Vector2(13,13)

# Called when the node enters the scene tree for the first time.
var body_data:Array 
var body:Array
var body_old:Array
 
# mov values
var up= Vector2(0,-1)
var down= Vector2(0,1)
var rigth= Vector2(1,0)
var left = Vector2(-1,0)

var m_act:Vector2=up
var move_act:bool=true


func _ready():
	pass
	
	
func create_all():
	generate_body()
	#start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if move_act:
		move_snake()
		view_snake()
		move_act=false
		mov.emit()

func get_body_data():
	return body_data
func view_snake():
	
	body_old=[]+body_data
	body_data[0]+=m_act
	for i in range(len(body_data)):
		if i>0:
			body_data[i]=body_old[i-1]
		
		var sn=body[i]
		body_data[i]=transfer_position(body_data[i],number_cells)
		sn.position=(body_data[i]*cell_size)+Vector2(0,cell_size)
		
		if i==0: 
			sn.animation_head(sn,m_act)
		else:
			if i %  2==0:
				sn.skin_body1()
			else:
				sn.skin_body2()
func transfer_position(cell,numberCells):
	
	var v_x=int(cell.x)
	var v_y=int(cell.y)
	if v_x<0:
		v_x =number_cells+v_x+1
	elif v_x>number_cells:
		v_x =v_x-number_cells-1
	if v_y<0:
		v_y= number_cells+v_y+1
	elif v_y>number_cells:
		v_y= v_y-number_cells-1
	cell.x=v_x
	cell.y=v_y
	return cell

func move_snake():
	if Input.is_action_pressed("move_rigth") and m_act!=left:
		m_act=rigth
	elif Input.is_action_pressed("move_left") and m_act!=rigth:
		m_act=left
	elif Input.is_action_pressed("move_up")and m_act!=down:
		m_act=up
	elif Input.is_action_pressed("move_down")and  m_act!=up:
		m_act=down
	

func generate_body():
	body_data.clear()
	body.clear()
	body_old.clear()
	add_segment(position_init)
	add_segment(position_init+Vector2(0,1))
	add_segment(position_init+Vector2(0,2))
	
	

func add_segment(pos):
	body_data.append(pos)
	var snake_segment=body_snake.instantiate()
	snake_segment.position=(pos*cell_size)+Vector2(0,cell_size)
	add_child(snake_segment)
	body.append(snake_segment)
	


func remove_node_child():
	for n in body:
		self.remove_child(n)
		n.queue_free()

func start_game():
	$moved_timer.start()
	create_all()

func add_last():
	var i=len(body_data)-1
	add_segment(body_data[i])

func _on_moved_timer_timeout():
	move_act=true
	
func over():
	$moved_timer.stop()
