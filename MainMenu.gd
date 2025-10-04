extends Control

@onready var start_button := $StartButton
@onready var exit_button := $ExitButton

func _ready():
	print("Main Menu ready.")
	# Connect buttons
	start_button.pressed.connect(_on_start_game_pressed)
	exit_button.pressed.connect(_on_exit_game_pressed)

func _on_start_game_pressed():
	get_tree().change_scene_to_file("res://sprites/Gameplay.tscn") # This is the path to my gameplay scene

func _on_exit_game_pressed():
	get_tree().quit()  # This will close the game once the exit button is pressed
