extends CharacterBody2D

const JUMP_VELOCITY = -1000.0
const MAX_VELOCITY = 400
#const ACCELERATION = 1000
const ACCELERATION = 2000
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2

@onready var anim = $AnimationPlayer
func _ready():
	anim.play("fall")
	position = Vector2(7*16*2, 18*16*2)
	
func _physics_process(delta):
	
	if not is_on_floor():
		if velocity.y < gravity*2:
			velocity.y += gravity * delta
		if velocity.y >= 0:
			anim.play("fall")		
	else:
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
		if Input.is_action_pressed("fall"):
			position.y+=1
			
	if Input.is_action_pressed("move_left"):
		$Sprite2D.flip_h = true
		if velocity.x > -MAX_VELOCITY:
			velocity.x -= ACCELERATION * delta
		if is_on_floor():
			anim.play("run")
		else:
			anim.play("jump")
			
	elif Input.is_action_pressed("move_right"):
		$Sprite2D.flip_h = false
		if velocity.x < MAX_VELOCITY:
			velocity.x += ACCELERATION * delta
		if is_on_floor():
			anim.play("run")
		else:
			anim.play("jump")
			
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
		
	if velocity.is_zero_approx():
		anim.play("idle")
		
	if(move_and_slide()):
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var tile_map = collision.get_collider()
			var collision_coords = tile_map.local_to_map((collision.get_position()-(collision.get_normal()))/4)
			var source_id = tile_map.get_cell_source_id(0, collision_coords)
			var tile = tile_map.get_cell_atlas_coords(0, collision_coords)
			if tile == Vector2i(0,0) and source_id == 1:
				match collision.get_normal():
					Vector2(-1,0):
						velocity.x = -MAX_VELOCITY*2
					Vector2(1,0):
						velocity.x = MAX_VELOCITY*2
					Vector2(0,-1):
						velocity.y = -MAX_VELOCITY*2
					Vector2(0,1):
						velocity.x = MAX_VELOCITY*2

			
