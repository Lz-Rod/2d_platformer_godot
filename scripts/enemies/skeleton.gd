extends CharacterBody2D

enum SkeletonState{
	walk,
	hurt
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $"Area2D-hitbox"
@onready var wall_detector: RayCast2D = $"RayCast2D - wallDetector"
@onready var ground_detector: RayCast2D = $"RayCast2D - groundDetector"

const SPEED = 15.0
const JUMP_VELOCITY = -400.0

var status: SkeletonState

var direction = 1

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	match status:
		SkeletonState.walk:
			walk_state(delta)
		SkeletonState.hurt:
			hurt_state(delta)
	
	move_and_slide()
	
func go_to_walk_state():
	status = SkeletonState.walk
	anim.play("walk")
	
func go_to_hurt_state():
	status = SkeletonState.hurt
	anim.play("hurt")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	
func walk_state(_delta):
	velocity.x = SPEED * direction
	
	#IA do inimigo patrulhando
	if wall_detector.is_colliding() or ! ground_detector.is_colliding():
		scale.x *=-1
		direction *= -1
	
func hurt_state(_delta):
	pass
	
func take_damage():
	go_to_hurt_state()
