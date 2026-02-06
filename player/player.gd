extends CharacterBody2D
@onready var anims = $Animations

const GRAVITY = 1000
const SPEED = 300
const JUMP = -400

enum State { Idle, Run, Jump, Fall, Attack }

var current_state

func _on_animation_finished():
	if current_state == State.Attack:
		current_state = State.Idle

func _ready():
	current_state = State.Idle
	anims.animation_finished.connect(_on_animation_finished)
	
func _physics_process(_delta):
	player_falling(_delta)
	player_idle(_delta)
	player_run(_delta)
	player_jump(_delta)
	player_attack(_delta)
	
	move_and_slide()
	
	player_animations()
	
func player_falling(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	if !is_on_floor():
		velocity.y += 1000 * _delta
	if velocity.y > 0 and current_state != State.Attack:
		current_state = State.Fall
		anims.flip_h = false if direction > 0 else true

func player_idle(_delta):
	if is_on_floor() and current_state != State.Attack:
		current_state = State.Idle
		
func player_run(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if is_on_floor() and direction != 0 and current_state != State.Attack:
		current_state = State.Run
		anims.flip_h = false if direction > 0 else true

func player_jump(_delta):
	if Input.is_action_just_pressed("jump") and current_state != State.Attack and is_on_floor():
		velocity.y = JUMP
		current_state = State.Jump
	
	if !is_on_floor() and current_state == State.Jump:
		var direction = Input.get_axis("move_left", "move_right")
		velocity.x += direction * 100 * _delta
		anims.flip_h = false if direction > 0 else true
		
func player_attack(_delta):
	#var direction = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("attack") and current_state != State.Attack:
		current_state = State.Attack
		#anims.flip_h = false if direction > 0 else true

func player_animations():
	if current_state == State.Idle:
		anims.play("idle")
	elif current_state == State.Run:
		anims.play("run")
	elif current_state == State.Jump:
		anims.play("jump")
	elif current_state == State.Fall:
		anims.play("fall")
	elif current_state == State.Attack:
		anims.play("attack_1")
