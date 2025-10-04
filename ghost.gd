# Controls ghost movement in the game as the ghosts can move rendomly throughout the game and change directions when hitting walls

extends CharacterBody2D

@export var speed: float = 80.0        # Speed of the ghosts
var direction: Vector2 = Vector2.ZERO  # Current movement direction

func _ready():
	randomize()  # Ensures randomness for direction choices
	_pick_random_direction()  # Choose a starting direction
	
	# Connects the Area2D child (hitbox) to detect collisions with Pac-Man.
	if $Area2D:
		$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	# Continuously moves the ghosts in the chosen direction
	velocity = direction * speed
	move_and_slide()

	# If the ghost collides with a wall, this helps with picking a new random direction
	if get_slide_collision_count() > 0:
		_pick_random_direction()

func _pick_random_direction():
	# Randomly chooses between left, right, up, or down
	var dirs = [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	direction = dirs[randi() % dirs.size()]
