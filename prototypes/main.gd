extends Node3D

## main.gd
## Controller for the 3D prototype world arena.
## Displays the active session status and provides navigation back to MainMenu.

@onready var session_badge: Label = %SessionBadge
@onready var return_menu_button: Button = %ReturnMenuButton

func _ready() -> void:
	var session_mgr = get_node_or_null("/root/SessionManager")
	if session_mgr and session_mgr.is_logged_in:
		session_badge.text = "✨ Active Doll: " + session_mgr.username + " (" + ("Guest Mode" if session_mgr.is_guest else "User") + ")"
	else:
		session_badge.text = "✨ Sandbox Mode (No Active Session)"
		
	return_menu_button.pressed.connect(_on_return_menu_pressed)
	print("[PrototypeWorld] Loaded. Floor collision size: 20x0.2x20. Active session: ", session_mgr.username if session_mgr else "None")

func _on_return_menu_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred("res://scenes/main_menu/MainMenu.tscn")
