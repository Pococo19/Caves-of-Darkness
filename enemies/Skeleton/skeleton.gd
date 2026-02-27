extends CharacterBody2D

const GRAVITY = 1000
var health = 6
@onready var area = $Hurtbox
@onready var anims = $AnimatedSprite2D

enum State { Idle, Walk, Hurt, Die }

var current_state

func _on_animation_finished():
	if current_state == State.Die:
		queue_free()
		return
	if current_state == State.Hurt:
		current_state = State.Idle

func _ready():
	current_state = State.Idle
	anims.animation_finished.connect(_on_animation_finished)
	
func _physics_process(delta: float):
	enemy_gravity(delta)
	
	move_and_slide()
	
	enemy_animations()

func enemy_gravity(delta : float):
	velocity.y += GRAVITY * delta

func _on_hurtbox_area_entered(area):
	health -= 1
	print("Hit!!!")
	print(health)
	if health == 0:
		current_state = State.Die
		return
	if current_state != State.Hurt:
		current_state = State.Hurt

func enemy_animations():
	if current_state == State.Idle:
		anims.play("idle")
	if current_state == State.Walk:
		anims.play("walk")
	if current_state == State.Hurt:
		anims.play("hurt")
	if current_state == State.Die:
		anims.play("die")
