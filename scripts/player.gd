extends CharacterBody2D
@onready var player: AnimatedSprite2D = $AnimatedSprite2D
@onready var mining_area: TileMapLayer = get_tree().get_first_node_in_group("mining_area")
@onready var rails_area: TileMapLayer = get_tree().get_first_node_in_group("rails_area")

const SPEED = 300.0
const JUMP_VELOCITY = -300.0

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle Walk	
	if Input.is_action_pressed("right"):
		if position.y > 170:
			player.animation = "mine_right"	
			_mine_sideways(true)
		else:	
			player.animation = "walk"	
		
	elif Input.is_action_pressed("left"):
		player.flip_h = true
		
		if position.y > 170:
			player.animation = "mine_right"
			_mine_sideways(false)	
		else:	
			player.animation = "walk"
		
	elif Input.is_action_pressed("down"):
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
		
			#print("Player Touched: %s" % collider)
		
			if collider.is_in_group("rails_area"):
				print("The player hit a rail")
				player.animation = "ladder"
			else:
				player.animation = "mine_down"	
		
		# Mining Logic
		var target_pos = global_position + Vector2(0, 32)
		var tile_pos = mining_area.local_to_map(mining_area.to_local(target_pos))
		var atlas_coords = mining_area.get_cell_atlas_coords(tile_pos)
		var source_id = mining_area.get_cell_source_id(tile_pos)
	
		# print("Source ID: ", source_id)
		# print("Atlas Coords: ", atlas_coords)
	
		if source_id != -1:
			await get_tree().create_timer(1.0).timeout
			mining_area.set_cell(tile_pos, 0, Vector2i(0, 32))
			rails_area.set_cell(tile_pos, 0, Vector2i(0, 0))
		
			# print("Turned block into rail")
	elif Input.is_action_pressed("up"):
		if position.y > 170:
			velocity.y = -120
			player.animation = "ladder"	
					
	else:
		player.flip_h = false
		player.animation = "idle"
		

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _mine_sideways(right: bool) -> void:
	var player_local_pos = mining_area.to_local(global_position)
	var player_grid_coords = mining_area.local_to_map(player_local_pos)
	var block_to_delete_coords = Vector2i(0, 0)
	
	if right == true:
		block_to_delete_coords = player_grid_coords + Vector2i(1, 0)
	else:
		block_to_delete_coords = player_grid_coords + Vector2i(-1, 0)
	
	await get_tree().create_timer(1.0).timeout	
	mining_area.erase_cell(block_to_delete_coords)
	rails_area.erase_cell(block_to_delete_coords)
