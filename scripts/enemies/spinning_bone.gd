extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var speed = 60
var direction = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += speed * delta * direction

func set_direction(direction):
	self.direction = direction
	anim.flip_h = direction < 0
	#if direction > 0:
		#anim.flip_h = false
	#else:
		#anim.flip_h = true
