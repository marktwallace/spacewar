extends Area2D

signal hit

@export var player_color : Color = Color(1, 1, 1, 1) # Default color (white)
@export var player_type = "right"
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

func _ready():
	var animated_sprite = $AnimatedSprite2D # Replace 'AnimatedSprite2D' with the correct node name if different
	if animated_sprite != null:
		animated_sprite.modulate = player_color
	else:
		print("AnimatedSprite2D node not found")
	screen_size = get_viewport_rect().size
	print("screen_size is " + str(screen_size))
	hide()

func wrap(value, min, max):
	var range1 = max - min
	if value < min:
		return max - (min - value) % range1
	return min + (value - min) % range1

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.

	if player_type == "left":
		if Input.is_action_pressed("pl_move_right"):
			velocity.x += 1
		if Input.is_action_pressed("pl_move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("pl_move_down"):
			velocity.y += 1
		if Input.is_action_pressed("pl_move_up"):
			velocity.y -= 1
	else:
		if Input.is_action_pressed("pr_move_right"):
			velocity.x += 1
		if Input.is_action_pressed("pr_move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("pr_move_down"):
			velocity.y += 1
		if Input.is_action_pressed("pr_move_up"):
			velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	#print(player_type + " velocity is " + str(velocity))
	
	position += velocity * delta
	position.x = wrap(position.x, 0, screen_size.x)
	position.y = wrap(position.y, 0, screen_size.y)
	#position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		# See the note below about boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func start(pos):
	print("Player" + player_type +" started")
	position = pos
	show()
	$CollisionShape2D.disabled = false


func _on_area_entered(area):
	print("Collision with " + str(area))
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	#$CollisionShape2D.set_deferred("disabled", true)

