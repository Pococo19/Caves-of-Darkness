extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

const GRAVITY = 1000

var player : CharacterBody2D

func on_process(delta: float):
	pass
	
func on_physics_process(delta : float):
	character_body_2d.velocity.y += GRAVITY * delta
	
	if player:
		if character_body_2d.global_position.x > player.global_position.x:
			animated_sprite_2d.flip_h = true
		elif character_body_2d.global_position.x < player.global_position.x:
			animated_sprite_2d.flip_h = false
	
	animated_sprite_2d.play("attack")
	
	character_body_2d.velocity.x = 0
	character_body_2d.move_and_slide()
	
func enter():
	player = get_tree().get_first_node_in_group("Player") as CharacterBody2D
	print("ENTERING ATTACK STATE")
	print("Player found: ", player != null)
	print("AnimatedSprite2D: ", animated_sprite_2d != null)
	
func exit():
	pass
