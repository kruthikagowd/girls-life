extends Control

## AuthModal.gd
## Modal dialog handling Guest entry, Prototype Sign In, and Prototype Registration.

signal modal_closed()
signal guest_entry_confirmed(doll_name: String)

@onready var guest_tab_btn: Button = %GuestTabButton
@onready var sign_in_tab_btn: Button = %SignInTabButton
@onready var register_tab_btn: Button = %RegisterTabButton

@onready var guest_view: VBoxContainer = %GuestView
@onready var sign_in_view: VBoxContainer = %SignInView
@onready var register_view: VBoxContainer = %RegisterView

@onready var guest_name_input: LineEdit = %GuestNameInput
@onready var sign_in_user_input: LineEdit = %SignInUserInput
@onready var sign_in_password_input: LineEdit = %SignInPasswordInput
@onready var register_user_input: LineEdit = %RegisterUserInput
@onready var register_email_input: LineEdit = %RegisterEmailInput
@onready var register_password_input: LineEdit = %RegisterPasswordInput

@onready var status_label: Label = %StatusLabel

enum ViewMode { GUEST, SIGN_IN, REGISTER }
var current_mode: ViewMode = ViewMode.GUEST

func _ready() -> void:
	# Connect tab switch buttons
	guest_tab_btn.pressed.connect(_on_guest_tab_pressed)
	sign_in_tab_btn.pressed.connect(_on_sign_in_tab_pressed)
	register_tab_btn.pressed.connect(_on_register_tab_pressed)
	
	# Connect action buttons
	%EnterGuestButton.pressed.connect(_on_enter_guest_pressed)
	%SignInActionButton.pressed.connect(_on_sign_in_action_pressed)
	%RegisterActionButton.pressed.connect(_on_register_action_pressed)
	%CloseModalButton.pressed.connect(close_modal)
	
	# Start with Guest view
	_set_view_mode(ViewMode.GUEST)

func show_modal() -> void:
	visible = true
	_set_view_mode(ViewMode.GUEST)
	status_label.text = ""
	guest_name_input.grab_focus()

func close_modal() -> void:
	visible = false
	modal_closed.emit()

func _set_view_mode(mode: ViewMode) -> void:
	current_mode = mode
	guest_view.visible = (mode == ViewMode.GUEST)
	sign_in_view.visible = (mode == ViewMode.SIGN_IN)
	register_view.visible = (mode == ViewMode.REGISTER)
	
	# Highlight active tab button
	guest_tab_btn.modulate = Color(1.0, 1.0, 1.0) if mode == ViewMode.GUEST else Color(0.85, 0.85, 0.85)
	sign_in_tab_btn.modulate = Color(1.0, 1.0, 1.0) if mode == ViewMode.SIGN_IN else Color(0.85, 0.85, 0.85)
	register_tab_btn.modulate = Color(1.0, 1.0, 1.0) if mode == ViewMode.REGISTER else Color(0.85, 0.85, 0.85)
	status_label.text = ""

func _on_guest_tab_pressed() -> void:
	_set_view_mode(ViewMode.GUEST)

func _on_sign_in_tab_pressed() -> void:
	_set_view_mode(ViewMode.SIGN_IN)

func _on_register_tab_pressed() -> void:
	_set_view_mode(ViewMode.REGISTER)

func _on_enter_guest_pressed() -> void:
	var doll_name: String = guest_name_input.text.strip_edges()
	if doll_name.is_empty():
		doll_name = "GuestDoll"
		
	status_label.modulate = Color(0.3, 0.7, 0.3)
	status_label.text = "Entering world as " + doll_name + "..."
	
	# Start local guest session in singleton
	var session_mgr = get_node_or_null("/root/SessionManager")
	if session_mgr:
		session_mgr.start_guest_session(doll_name)
		
	guest_entry_confirmed.emit(doll_name)
	
	# Transition into the 3D prototype world
	get_tree().change_scene_to_file.call_deferred("res://prototypes/main.tscn")

func _on_sign_in_action_pressed() -> void:
	var user: String = sign_in_user_input.text.strip_edges()
	if user.is_empty():
		status_label.modulate = Color(0.8, 0.25, 0.35)
		status_label.text = "Please enter a username or email."
		return
		
	status_label.modulate = Color(0.5, 0.2, 0.5)
	status_label.text = "Online authentication connects in Phase 5!\nFor now, please use 'Continue as Guest' to enter."

func _on_register_action_pressed() -> void:
	var user: String = register_user_input.text.strip_edges()
	if user.is_empty():
		status_label.modulate = Color(0.8, 0.25, 0.35)
		status_label.text = "Please enter your doll name."
		return
		
	status_label.modulate = Color(0.5, 0.2, 0.5)
	status_label.text = "Account registration connects in Phase 5!\nUse 'Continue as Guest' to explore the world immediately."
