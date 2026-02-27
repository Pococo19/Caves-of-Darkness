extends CharacterBody2D
@onready var anims = $Animations
@onready var hitbox = $AttackHitbox
@onready var hitbox_collision = $AttackHitbox/CollisionShape2D

const GRAVITY = 1000
const WALL_GRAVITY = 800
const SPEED = 180
const SLIDE_SPEED = 300
const JUMP = -400
const WALL_JUMP = -450
const WALL_JUMP_PUSH = 400

enum State { Idle, Run, Jump, Fall, Attack, Slide, Wall, Special }

var current_state
var gravity_modifier = 1.0

func _on_animation_finished():
	if current_state == State.Attack or current_state == State.Slide or current_state == State.Special:
		current_state = State.Idle
		hitbox_collision.disabled = true

func _on_frame_changed():
	if current_state == State.Attack:
		if anims.frame >= 4 and anims.frame <= 7:
			hitbox_collision.disabled = false
		else:
			hitbox_collision.disabled = true
	elif current_state == State.Special:
		if anims.frame >= 5 and anims.frame <= 9:
			hitbox_collision.disabled = false
		else:
			hitbox_collision.disabled = true
	else:
		hitbox_collision.disabled = true

func _ready():
	add_to_group("Player")
	if RoomChangeGlobal.Activate:
		global_position = RoomChangeGlobal.PlayerPos
		RoomChangeGlobal.Activate = false
	current_state = State.Idle
	anims.animation_finished.connect(_on_animation_finished)
	anims.frame_changed.connect(_on_frame_changed)
	hitbox_collision.disabled = true
	
	var scene_path = get_tree().current_scene.scene_file_path
	if scene_path != null and scene_path.contains("testlevel2"):
		gravity_modifier = 0.3
	else:
		gravity_modifier = 1.0
	#print("DEBUG: Player ready - Hitbox setup complete")
	
func _physics_process(_delta):
	player_wall_slide(_delta)
	player_falling(_delta)
	player_idle(_delta)
	player_run(_delta)
	player_jump(_delta)
	player_attack(_delta)
	player_special(_delta)
	move_and_slide()
	
	player_animations()
	update_hitbox_position()
	
func player_falling(_delta):
	var direction = Input.get_axis("move_left", "move_right")
	var grav = 1000
	
	if current_state == State.Wall:
		grav = 100
	else:
		grav = 1000
	
	if !is_on_floor():
		if gravity_modifier < 1.0:
			# Constant slow fall speed for testlevel2
			velocity.y = 400
		else:
			velocity.y += grav * _delta

	if velocity.y > 0 and current_state != State.Attack and current_state != State.Special and current_state != State.Wall:
		current_state = State.Fall
		anims.flip_h = false if direction > 0 else true

func player_idle(_delta):
	if is_on_floor() and current_state != State.Attack and current_state != State.Special  and current_state != State.Slide:
		current_state = State.Idle
		
func player_run(_delta):
	if current_state == State.Slide:
		return
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if is_on_floor() and direction != 0 and current_state != State.Attack and current_state != State.Special  and current_state != State.Slide:
		current_state = State.Run
		anims.flip_h = false if direction > 0 else true
		
	if Input.is_action_just_pressed("slide") and current_state != State.Attack and current_state != State.Special and direction != 0 and is_on_floor():
		current_state = State.Slide
		velocity.x = direction * SLIDE_SPEED
		anims.flip_h = direction < 0

func player_jump(_delta):
	# Wall jump
	if current_state == State.Wall and Input.is_action_just_pressed("jump"):
		var wall_normal = get_wall_normal()
		velocity.y = WALL_JUMP
		velocity.x = wall_normal.x * WALL_JUMP_PUSH
		current_state = State.Jump
		anims.flip_h = wall_normal.x < 0
		return
	
	# Normal jump
	if Input.is_action_just_pressed("jump") and current_state != State.Attack and current_state != State.Special and is_on_floor():
		velocity.y = JUMP
		current_state = State.Jump
	
	if !is_on_floor() and current_state == State.Jump:
		var direction = Input.get_axis("move_left", "move_right")
		velocity.x += direction * 100 * _delta
		anims.flip_h = false if direction > 0 else true

func player_wall_slide(_delta):
	if !is_on_floor() and is_on_wall() and current_state == State.Fall:
		current_state = State.Wall
	if !is_on_wall() and current_state == State.Wall:
		current_state = State.Fall
	
	if current_state == State.Wall:
		var wall_normal = get_wall_normal()
		velocity.x = -wall_normal.x * 50
	
func player_attack(_delta):
	var direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("attack") and current_state != State.Attack:
		current_state = State.Attack
		
		# DOWN ATTACK en l'air
		if !is_on_floor() and Input.is_action_pressed("move_down"):
			print("DATTAACK")
			
			# rotation selon la direction
			if anims.flip_h:
				anims.rotation_degrees = -50   # gauche
			else:
				anims.rotation_degrees = 50  # droite
				
		else:
			anims.rotation_degrees = 0

	# remettre la rotation quand l’attaque est finie
	if current_state != State.Attack:
		anims.rotation_degrees = 0

func player_special(_delta):
	var direction = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("special") and current_state != State.Special:
		current_state = State.Special
		
		# DOWN ATTACK en l'air
		if !is_on_floor() and Input.is_action_pressed("move_down"):
			print("DATTAACK")
			
			# rotation selon la direction
			if anims.flip_h:
				anims.rotation_degrees = -50   # gauche
			else:
				anims.rotation_degrees = 50  # droite
				
		else:
			anims.rotation_degrees = 0

	# remettre la rotation quand l’attaque est finie
	if current_state != State.Special:
		anims.rotation_degrees = 0

	
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
	elif current_state == State.Special:
		anims.play("attack_2")
	elif current_state == State.Slide:
		anims.play("slide")
	elif current_state == State.Wall:
		anims.play("wall")

func update_hitbox_position():
	# Ajuste la position de la hitbox selon la direction du personnage
	if anims.flip_h:
		hitbox.position.x = -25  # Gauche
	else:
		hitbox.position.x = 25   # Droite
