extends Node

## SessionManager.gd
## Manages active player credentials, local guest sessions, and user state.

var is_logged_in: bool = false
var is_guest: bool = false
var user_id: String = ""
var username: String = ""
var email: String = ""
var auth_token: String = ""
var appearance_data: Dictionary = {}

func _ready() -> void:
	print("[SessionManager] Initialized. Ready for session management.")

## Begins a local guest session without requiring remote network authentication.
func start_guest_session(custom_name: String = "") -> Dictionary:
	var final_name: String = custom_name.strip_edges()
	if final_name.is_empty():
		final_name = "GuestDoll"
	
	is_logged_in = true
	is_guest = true
	user_id = "guest_" + str(randi_range(1000, 9999))
	username = final_name
	email = ""
	auth_token = "local_guest_token_" + str(Time.get_unix_time_from_system())
	
	# Default starter appearance dictionary (used in Phase 2)
	appearance_data = {
		"doll_name": username,
		"skin_tone_index": 0,
		"eye_color_index": 0,
		"hair_style": "default",
		"hair_color_index": 0
	}
	
	var session_payload: Dictionary = get_session_data()
	print("[SessionManager] Guest session started for: %s (ID: %s)" % [username, user_id])
	
	var events = get_node_or_null("/root/GameEvents")
	if events:
		events.session_started.emit(session_payload)
		
	return session_payload

## Simulates a local login attempt (for UI prototype purposes in Phase 1)
func login_local_mock(user_input: String) -> Dictionary:
	var clean_user: String = user_input.strip_edges()
	if clean_user.is_empty():
		clean_user = "Fashionista"
		
	is_logged_in = true
	is_guest = false
	user_id = "mock_" + str(randi_range(10000, 99999))
	username = clean_user
	email = clean_user.to_lower() + "@projecther.local"
	auth_token = "mock_jwt_token_" + str(Time.get_unix_time_from_system())
	
	var session_payload: Dictionary = get_session_data()
	print("[SessionManager] Mock user login for: %s" % username)
	
	var events = get_node_or_null("/root/GameEvents")
	if events:
		events.session_started.emit(session_payload)
		
	return session_payload

## Ends the active session and resets state
func end_session() -> void:
	print("[SessionManager] Ending active session for: %s" % username)
	is_logged_in = false
	is_guest = false
	user_id = ""
	username = ""
	email = ""
	auth_token = ""
	appearance_data.clear()
	
	var events = get_node_or_null("/root/GameEvents")
	if events:
		events.session_ended.emit()

## Returns the current session state as a dictionary
func get_session_data() -> Dictionary:
	return {
		"is_logged_in": is_logged_in,
		"is_guest": is_guest,
		"user_id": user_id,
		"username": username,
		"email": email,
		"auth_token": auth_token,
		"appearance_data": appearance_data
	}
