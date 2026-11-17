extends Control

## MainMenu.gd
## Main Menu controller for PROJECT HER.
## Coordinates Play/Auth flow, Character Salon preview, Settings, and Game Exit.

@onready var play_button: Button = %PlayButton
@onready var salon_button: Button = %SalonButton
@onready var settings_button: Button = %SettingsButton
@onready var exit_button: Button = %ExitButton

@onready var auth_modal: Control = %AuthModal
@onready var salon_modal: Control = %SalonModal
@onready var settings_modal: Control = %SettingsModal

@onready var volume_slider: HSlider = %VolumeSlider
@onready var fullscreen_checkbox: CheckBox = %FullscreenCheckbox

func _ready() -> void:
	# Connect main navigation buttons
	play_button.pressed.connect(_on_play_pressed)
	salon_button.pressed.connect(_on_salon_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
	# Connect salon modal buttons
	%CloseSalonButton.pressed.connect(_on_close_salon_pressed)
	
	# Connect settings modal buttons
	%CloseSettingsButton.pressed.connect(_on_close_settings_pressed)
	volume_slider.value_changed.connect(_on_volume_changed)
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	
	# Hide all overlays initially
	auth_modal.visible = false
	salon_modal.visible = false
	settings_modal.visible = false
	
	# Initial settings sync
	var is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	fullscreen_checkbox.button_pressed = is_fullscreen
	
	print("[MainMenu] Loaded successfully. Welcome to PROJECT HER.")

func _on_play_pressed() -> void:
	auth_modal.show_modal()

func _on_salon_pressed() -> void:
	salon_modal.visible = true
	var events = get_node_or_null("/root/GameEvents")
	if events:
		events.character_salon_requested.emit()

func _on_close_salon_pressed() -> void:
	salon_modal.visible = false

func _on_settings_pressed() -> void:
	settings_modal.visible = true
	var events = get_node_or_null("/root/GameEvents")
	if events:
		events.settings_requested.emit()

func _on_close_settings_pressed() -> void:
	settings_modal.visible = false

func _on_exit_pressed() -> void:
	print("[MainMenu] Exiting game.")
	get_tree().quit()

func _on_volume_changed(val: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(val / 100.0))

func _on_fullscreen_toggled(button_pressed: bool) -> void:
	if button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
