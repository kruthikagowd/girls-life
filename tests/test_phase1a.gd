extends SceneTree

func _init() -> void:
	print("--- BEGIN PHASE 1A AUTOMATED VERIFICATION ---")
	
	# Instantiate autoload singletons for standalone test execution
	var GameEventsScript = load("res://core/GameEvents.gd")
	var GameEvents = GameEventsScript.new()
	GameEvents.name = "GameEvents"
	root.add_child(GameEvents)
	
	var SessionManagerScript = load("res://core/SessionManager.gd")
	var SessionManager = SessionManagerScript.new()
	SessionManager.name = "SessionManager"
	root.add_child(SessionManager)
	
	# Test 1: Autoloads check
	print("[TEST 1] Verifying SessionManager...")
	assert(SessionManager != null, "SessionManager autoload missing!")
	assert(GameEvents != null, "GameEvents autoload missing!")
	print("  -> SessionManager and GameEvents initialized.")
	
	# Test 2: Guest Session creation
	print("[TEST 2] Testing Guest Session logic...")
	var session = SessionManager.start_guest_session("SakuraDoll")
	assert(session.is_logged_in == true, "Guest should be logged in")
	assert(session.is_guest == true, "Guest flag should be true")
	assert(session.username == "SakuraDoll", "Username should be SakuraDoll")
	assert(session.user_id.begins_with("guest_"), "User ID should begin with guest_")
	print("  -> Guest Session verified: ", session.username, " (ID: ", session.user_id, ")")
	
	# Test 3: Load MainMenu.tscn
	print("[TEST 3] Loading MainMenu.tscn...")
	var menu_scene = load("res://scenes/main_menu/MainMenu.tscn")
	assert(menu_scene != null, "Failed to load MainMenu.tscn")
	var menu_instance = menu_scene.instantiate()
	assert(menu_instance != null, "Failed to instantiate MainMenu.tscn")
	root.add_child(menu_instance)
	print("  -> MainMenu.tscn instantiated and added to root.")
	
	# Test 4: Verify MainMenu controls
	print("[TEST 4] Verifying MainMenu controls...")
	var play_btn = menu_instance.get_node("%PlayButton")
	var salon_btn = menu_instance.get_node("%SalonButton")
	var settings_btn = menu_instance.get_node("%SettingsButton")
	var exit_btn = menu_instance.get_node("%ExitButton")
	var auth_modal = menu_instance.get_node("%AuthModal")
	var salon_modal = menu_instance.get_node("%SalonModal")
	var settings_modal = menu_instance.get_node("%SettingsModal")
	
	assert(play_btn != null, "PlayButton missing")
	assert(salon_btn != null, "SalonButton missing")
	assert(settings_btn != null, "SettingsButton missing")
	assert(exit_btn != null, "ExitButton missing")
	assert(auth_modal != null, "AuthModal missing")
	assert(salon_modal != null, "SalonModal missing")
	assert(settings_modal != null, "SettingsModal missing")
	
	# Test opening AuthModal
	play_btn.emit_signal("pressed")
	assert(auth_modal.visible == true, "AuthModal should be visible after Play pressed")
	print("  -> Play button opened AuthModal.")
	
	# Test closing AuthModal
	var close_btn = auth_modal.get_node("%CloseModalButton")
	close_btn.emit_signal("pressed")
	assert(auth_modal.visible == false, "AuthModal should be hidden after Close pressed")
	print("  -> Close button closed AuthModal.")
	
	# Test opening SalonModal
	salon_btn.emit_signal("pressed")
	assert(salon_modal.visible == true, "SalonModal should be visible after Salon pressed")
	var close_salon = menu_instance.get_node("%CloseSalonButton")
	close_salon.emit_signal("pressed")
	assert(salon_modal.visible == false, "SalonModal should be hidden after Close pressed")
	print("  -> SalonModal opened and closed.")
	
	# Test opening SettingsModal
	settings_btn.emit_signal("pressed")
	assert(settings_modal.visible == true, "SettingsModal should be visible after Settings pressed")
	var close_settings = menu_instance.get_node("%CloseSettingsButton")
	close_settings.emit_signal("pressed")
	assert(settings_modal.visible == false, "SettingsModal should be hidden after Close pressed")
	print("  -> SettingsModal opened and closed.")
	
	menu_instance.queue_free()
	
	# Test 5: Verify prototypes/main.tscn
	print("[TEST 5] Loading and verifying prototypes/main.tscn...")
	var main_scene = load("res://prototypes/main.tscn")
	assert(main_scene != null, "Failed to load prototypes/main.tscn")
	var main_instance = main_scene.instantiate()
	assert(main_instance != null, "Failed to instantiate prototypes/main.tscn")
	root.add_child(main_instance)
	
	var static_body = main_instance.get_node_or_null("StaticBody3D")
	assert(static_body != null, "StaticBody3D missing in main.tscn")
	var mesh_inst = static_body.get_node_or_null("MeshInstance3D")
	assert(mesh_inst != null, "MeshInstance3D missing in main.tscn")
	var col_shape = static_body.get_node_or_null("CollisionShape3D")
	assert(col_shape != null, "CollisionShape3D missing in main.tscn")
	
	var floor_box: BoxShape3D = col_shape.shape as BoxShape3D
	assert(floor_box != null, "Shape should be BoxShape3D")
	assert(floor_box.size == Vector3(20, 0.2, 20), "Collision box size must match 20x0.2x20")
	print("  -> Floor collision confirmed: ", floor_box.size)
	
	var light = main_instance.get_node_or_null("DirectionalLight3D")
	assert(light != null, "DirectionalLight3D missing in main.tscn")
	var env = main_instance.get_node_or_null("WorldEnvironment")
	assert(env != null, "WorldEnvironment missing in main.tscn")
	var cam = main_instance.get_node_or_null("Camera3D")
	assert(cam != null, "Camera3D missing in main.tscn")
	var hud_badge = main_instance.get_node("%SessionBadge")
	assert(hud_badge != null, "SessionBadge missing in HUD")
	print("  -> Environment, light, camera, and HUD confirmed in prototypes/main.tscn.")
	
	main_instance.queue_free()
	
	print("--- ALL PHASE 1A VERIFICATIONS PASSED SUCCESSFULLY! ---")
	quit(0)
