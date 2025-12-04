extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump,
	fall,
	crouch,
	slide
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var coll: CollisionShape2D = $CollisionShape2D

@export var max_speed = 180.0
@export var acceleration = 400
@export var deceleration = 400
@export var slide_deceleration = 100
const JUMP_VELOCITY = -300.0

var jump_count = 0
@export var max_jump_count = 2

var direction = 0
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
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump:
			jump_state(delta)
		PlayerState.fall:
			fall_state(delta)
		PlayerState.crouch:
			crouch_state(delta)
		PlayerState.slide:
			slide_state(delta)
			
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
	jump_count += 1
	
func go_to_fall_state():
	status = PlayerState.fall
	anim.play("fall"
	)
	
func go_to_crouch_state():
	status = PlayerState.crouch
	anim.play("crouch")
	set_collide_size(10,10,3)

	
func exit_from_crouch_state():
	set_collide_size(10,14,1)
	
func go_to_slide_state():
	status = PlayerState.slide
	anim.play("slide")
	set_collide_size(10,10,3)
	
func exit_from_slide_state():
	set_collide_size(10,14,1)

#essas funções determinam o que acontece em cada estado
func idle_state(delta):
	move(delta)
	if velocity.x != 0:
		go_to_walk_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
		
	if Input.is_action_pressed("crouch"):
		go_to_crouch_state()
		return
	
func walk_state(delta):
	move(delta)
	if velocity.x == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	# ativa a animação de fall quando ele and para fora de uma plataforma e desconta um pulo para que ele nao possa dar um pulo triploo
	if !is_on_floor():
		jump_count += 1
		go_to_fall_state()
		return
		
	if Input.is_action_just_pressed("crouch"):
		go_to_slide_state()
		return
	
func jump_state(delta):
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()		
		return
		
	if velocity.y > 0:
		go_to_fall_state()
		return
				
func fall_state(delta):
	move(delta)
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if is_on_floor():
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()			
		else:
			go_to_walk_state()
		return

func crouch_state(_delta):
	update_direction()
	if Input.is_action_just_released("crouch"):
		exit_from_crouch_state()
		go_to_idle_state()
	return
	
func slide_state(delta):
	velocity.x = move_toward(velocity.x, 0, slide_deceleration * delta)
	
	if Input.is_action_just_released("crouch"):
		exit_from_slide_state()
		go_to_walk_state()
		return
		
	if velocity.x == 0:
		exit_from_slide_state()
		go_to_crouch_state()
		return
#atualiza a velocidade do player e faz a animação flipar
func move(delta):
	update_direction()
			
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
		
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		
func update_direction():
	direction = Input.get_axis("left", "right")
	
	if direction < 0:
		anim.flip_h = true		
	elif direction > 0:
		anim.flip_h = false

#função que retorna verdadeiro se jump_count for menor que max_jump_count
func can_jump() -> bool:
	return jump_count < max_jump_count

func set_collide_size(x, y, pos):
	coll.shape.size = Vector2(x,y)
	coll.position.y = pos
