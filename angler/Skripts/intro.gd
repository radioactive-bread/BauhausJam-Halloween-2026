extends Control

const GAME_SCENE := "res://Skripts/Angler.tscn"
const LINKEDIN_SECONDS := 10.0

@onready var start_screen: Control = $StartScreen
@onready var linkedin_screen: Control = $LinkedInScreen
@onready var play_button: Button = $StartScreen/PlayButton

var _showing_linkedin := false

func _ready() -> void:
	start_screen.visible = true
	linkedin_screen.visible = false
	play_button.pressed.connect(_on_play_pressed)
	play_button.grab_focus()

func _on_play_pressed() -> void:
	start_screen.visible = false
	linkedin_screen.visible = true
	_showing_linkedin = true
	await get_tree().create_timer(LINKEDIN_SECONDS).timeout
	_start_game()

# Klick oder Taste überspringt das LinkedIn-Bild
func _unhandled_input(event: InputEvent) -> void:
	if not _showing_linkedin:
		return
	if (event is InputEventMouseButton and event.pressed) or (event is InputEventKey and event.pressed):
		_start_game()

func _start_game() -> void:
	if not _showing_linkedin:
		return
	_showing_linkedin = false
	get_tree().change_scene_to_file(GAME_SCENE)
