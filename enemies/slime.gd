extends CharacterBody2D

const GRAVITY = 1000
const SPEED = 15
var health = 2
@onready var area = $Hurtbox
@onready var anims = $AnimatedSprite2D

@export var patrol: Node

enum State { Idle, Walk, Hurt, Die }

var current_state
var direction: Vector2 = Vector2.LEFT
var number_pts: int
var pts_pos: Array[Vector2]
var current_point: Vector2
var current_point_pos: int = 0

func _on_animation_finished():
	if current_state == State.Die:
		queue_free()
		return
	if current_state == State.Hurt:
		current_state = State.Walk

func _ready():
	if patrol != null:
		number_pts = patrol.get_children().size()
		for point in patrol.get_children():
			pts_pos.append(point.global_position)
		if number_pts > 0:
			current_point = pts_pos[current_point_pos]
	current_state = State.Idle
	anims.animation_finished.connect(_on_animation_finished)
	
func _physics_process(delta: float):
	enemy_gravity(delta)
	if patrol != null and number_pts > 0:
		enemy_walk(delta)
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
		anims.flip_h = direction.x < 0
	if current_state == State.Hurt:
		anims.play("hurt")
	if current_state == State.Die:
		anims.play("die")

func enemy_walk(delta: float):
	if current_state == State.Hurt or current_state == State.Die:
		velocity.x = 0
		return
		
	var distance = global_position.distance_to(current_point)
	
	if distance <= 5:
		current_point_pos = (current_point_pos + 1) % number_pts
		current_point = pts_pos[current_point_pos]
		direction = (current_point - global_position).normalized()
	else:
		direction = (current_point - global_position).normalized()
		velocity.x = direction.x * SPEED
		current_state = State.Walk
