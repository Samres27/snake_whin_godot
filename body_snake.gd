extends Area2D

var counter=50
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func animation_head(head,velocity):
	if velocity.x !=0:
		$AnimatedSprite2D.animation= "Hrigth"
		$AnimatedSprite2D.flip_h= velocity.x<0
		
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "Hup"
		$AnimatedSprite2D.flip_v = velocity.y > 0
	return head
func skin_head():
	$AnimatedSprite2D.animation= "Hrigth"

func skin_body1():
	$AnimatedSprite2D.animation= "body1"
	
func skin_body2():
	$AnimatedSprite2D.animation= "body2"
