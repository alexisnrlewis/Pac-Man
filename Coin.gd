# Controls the behavior of collectible coins in the Pac-Man game. When Pac-Man touches a coin his score increases and the coin disappears from the game screen

extends Area2D

func _ready() -> void:
	# Connects the built-in "body_entered" signal to the local function. Allows the coin to detect when Pac-Man overlaps with it
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# Check if the body that entered is Pac-Man (who is in the "Player" group)
	if body.is_in_group("Player"):
		body.increase_score()  # Calls Pac-Man’s function to increase the score
		queue_free()           # Removes the coin from the game after being collected
