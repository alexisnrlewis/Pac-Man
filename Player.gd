# This script manages the gameplay such as the movement of the player (or Pac-Man), the players score/amt of coins left, collision detection with ghosts (enemies), and the Game Over screen.

extends CharacterBody2D

@export var speed: float = 150.0    # Speed at which Pac-Man moves
var score: int = 0                  # Player’s current score
var total_coins: int = 57           # Total number of coins in the level
var remaining_coins: int = total_coins
var max_time: float = 300.0         # Maximum allowed time in seconds
var elapsed_time: float = 0.0       # Timer to track game duration
var score_label: Label              # Label for score display on screen
var coins_label: Label              # Label for coins left
var is_dead: bool = false           # Prevents multiple deaths or repeated game over triggers

@onready var game_node = get_parent()
@onready var pause_button: Button = $"../PauseMenu/PauseButton"

func _ready() -> void:
	# Adds Pac-Man to the "Player" group and initializes HUD labels
	add_to_group("Player")
	
	# Displays the current score on the screen
	score_label = Label.new()
	score_label.text = "Score: 0"
	score_label.position = Vector2(10, 10)
	add_child(score_label)
	
	# Shows the amt of remaining coins on the screen
	coins_label = Label.new()
	coins_label.text = "Coins Left: " + str(remaining_coins)
	coins_label.position = Vector2(10, 30)
	add_child(coins_label)
	
	print("Player ready. parent:", game_node)

func _physics_process(delta: float) -> void:
	# Controls movement and game logic
	# Stops processing if game is paused or Pac-Man is dead
	if get_tree().paused or is_dead:
		return
	
	# Movement system:
	# Uses Godot’s built-in input actions the such as the arrow keys
	var direction: = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	
	# Apply velocity to Pac-Man and move
	velocity = direction * speed
	move_and_slide()  # Moves the player with collision response
	
	# Updates the timer
	elapsed_time += delta
	
	# Time-based game over condition
	if elapsed_time >= max_time:
		game_over("Time's up!")
		return
	
	# Check for ghost collisions on each frame
	check_ghost_collisions()

func increase_score(points: int = 10) -> void:
	# Adds points when a coin is collected
	if get_tree().paused or is_dead:
		return
	score += points
	update_score_display()
	decrease_coin_count()

func update_score_display() -> void:
	# Updates score label on screen.
	if score_label:
		score_label.text = "Score: " + str(score)

func decrease_coin_count() -> void:
	# Reduces remaining coins after collection and updates the label
	remaining_coins -= 1
	if coins_label:
		coins_label.text = "Coins Left: " + str(remaining_coins)
	
	# When no coins remain the player wins the game
	if remaining_coins <= 0:
		game_over("You collected all coins!")

func check_ghost_collisions() -> void:
	# Loops through all enemies (ghosts)
	# If Pac-Man comes too close to a ghost he will die
	if is_dead:
		return
		
	for ghost in get_tree().get_nodes_in_group("Enemy"):
		if ghost and is_instance_valid(ghost):
			var distance = global_position.distance_to(ghost.global_position)
			if distance < 5: # Small radius for ghost collision
				print("Ghost collision at distance:", distance)
				die()
				return

func die() -> void:
	# Handles Pac-Man’s death if he is caught by a ghost
	if is_dead:
		return
	is_dead = true
	game_over("You were caught by a ghost!")

func game_over(reason: String) -> void:
	# Triggers the end of the game with a message
	# Prevents duplicate alerts if player is already dead
	if is_dead and reason != "You were caught by a ghost!":
		return  
	
	OS.alert("Game Over!\n" + reason + "\nFinal Score: " + str(score) + "\nCoins Collected: " + str(total_coins - remaining_coins))
	get_tree().paused = true  # Freezes the game after Game Over
