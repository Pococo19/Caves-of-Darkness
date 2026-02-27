extends Area2D

@export var ConnectedRoom: String

@export var PlayerPos: Vector2
@export var PlayerJumpOnEnter: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("player")
		RoomChangeGlobal.Activate = true
		RoomChangeGlobal.PlayerPos = PlayerPos
		RoomChangeGlobal.PlayerJumpOnEnter = PlayerJumpOnEnter
		LevelTransition.change_to_scene(ConnectedRoom)
