# Handles the pause and resume functionality in the game using a button in the user interface

extends CanvasLayer

@onready var pause_button = $PauseButton
# Grabs a reference to the Pause button in the scene so it can be used in the script

func _ready():
	# When the pause button is pressed it will trigger the _on_pause_button_pressed function
	pause_button.pressed.connect(_on_pause_button_pressed)

func _on_pause_button_pressed():
	# Toggles between pausing and resuming the game
	if get_tree().paused:
		# This function will resume the game if the game is currently paused 
		get_tree().paused = false
		pause_button.text = "Pause"  # Updates button label
	else:
		# This function will pause the game if the game is running
		get_tree().paused = true
		pause_button.text = "Resume"  # Update button label
