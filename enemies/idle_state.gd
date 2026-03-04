extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var patrol: Node
@export var speed: int = 35

const GRAVITY = 1000

var direction: Vector2 = Vector2.RIGHT
var number_pts: int
var pts_pos: Array[Vector2]
var current_point: Vector2
var current_point_pos: int = 0

func on_process(delta: float):
	pass
	
func on_physics_process(delta : float):
	character_body_2d.velocity.y += GRAVITY * delta
	
	print("Idle state running")
	print("Patrol: ", patrol)
	print("Number pts: ", number_pts)
	
	if patrol != null and number_pts > 0:
		var distance = character_body_2d.global_position.distance_to(current_point)
		
		print("Distance to point: ", distance)
		print("Current point: ", current_point)
		
		if distance <= 5:
			current_point_pos = (current_point_pos + 1) % number_pts
			current_point = pts_pos[current_point_pos]
			direction = (current_point - character_body_2d.global_position).normalized()
		else:
			direction = (current_point - character_body_2d.global_position).normalized()
			character_body_2d.velocity.x = direction.x * speed
			animated_sprite_2d.play("walk")
			animated_sprite_2d.flip_h = direction.x < 0
			print("Velocity set to: ", character_body_2d.velocity)
	else:
		print("No patrol or no points!")
	
	character_body_2d.move_and_slide()
	
func enter():
	print("ENTERING IDLE STATE")
	
	# Si patrol n'est pas assigné, chercher dans les enfants du skeleton
	if patrol == null and character_body_2d:
		for child in character_body_2d.get_children():
			if child.name.to_lower().contains("patrol") or child is Node2D and child.get_child_count() > 0:
				patrol = child
				print("Auto-found patrol node: ", patrol.name)
				break
	
	print("Patrol node: ", patrol)
	if patrol != null:
		number_pts = patrol.get_children().size()
		print("Number of patrol points: ", number_pts)
		pts_pos.clear()
		for point in patrol.get_children():
			pts_pos.append(point.global_position)
			print("Added patrol point: ", point.global_position)
		if number_pts > 0:
			current_point = pts_pos[current_point_pos]
			print("Starting point: ", current_point)
	
func exit():
	pass
