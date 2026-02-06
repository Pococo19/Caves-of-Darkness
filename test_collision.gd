extends Node2D

func _ready():
	print("=== COLLISION DEBUG ===")
	
	# Check player
	var player = $"Node2D"
	if player:
		print("Player collision_layer: ", player.collision_layer)
		print("Player collision_mask: ", player.collision_mask)
		print("Player position: ", player.position)
	
	# Check tilemap
	var tilemap = $TileMapLayer
	if tilemap:
		print("TileMap found")
		var tileset = tilemap.tile_set
		if tileset:
			print("TileSet physics layer count: ", tileset.get_physics_layers_count())
			if tileset.get_physics_layers_count() > 0:
				print("TileSet physics layer 0 collision_layer: ", tileset.get_physics_layer_collision_layer(0))
				print("TileSet physics layer 0 collision_mask: ", tileset.get_physics_layer_collision_mask(0))
		
		# Check what tiles are actually placed
		var used_cells = tilemap.get_used_cells()
		print("Number of tiles placed: ", used_cells.size())
		if used_cells.size() > 0:
			var first_cell = used_cells[0]
			print("First tile position: ", first_cell)
			var tile_data = tilemap.get_cell_tile_data(first_cell)
			if tile_data:
				print("Tile has collision: ", tile_data.get_collision_polygons_count(0) > 0)
