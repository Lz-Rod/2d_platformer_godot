extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump,
	crouch
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 80.0
const JUMP_VELOCITY = -300.0

var status: PlayerState

#essa função inicia o jogo em idle
func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	
	#adiciona a gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump:
			jump_state()
		PlayerState.crouch:
			crouch_state()
			
	move_and_slide()

#essas funções fazem o estado alterar
func go_to_idle_state():
	status = PlayerState.idle
	anim.play("idle")

func go_to_walk_state():
	status = PlayerState.walk
	anim.play("walk")
	
func go_to_jump_state():
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
	
func go_to_crouch_state():
	status = PlayerState.crouch
	anim.play("crouch")

#essas funções determinam o que acontece em cada estado
func idle_state():
	move()
	if velocity.x != 0:
		go_to_walk_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
		
	if Input.is_action_pressed("crouch"):
		go_to_crouch_state()
		return
	
func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
func jump_state():
	move()
	if is_on_floor():
		
		if velocity.x == 0:
			go_to_idle_state()			
		else:
			go_to_walk_state()
		return

func crouch_state():
	if Input.is_action_just_released("crouch"):
		go_to_idle_state()
	return
	
#atualiza a velocidade do player e faz a animação flipar
func move():
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction < 0:
		anim.flip_h = true		
	elif direction > 0:
		anim.flip_h = false
