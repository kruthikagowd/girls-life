extends Node

func _ready() -> void:
	print("\n==================================================")
	print("  RUNNING PROJECT HER PHASE 1A INTEGRATION TEST")
	print("==================================================")
	
	# Verify singletons
	assert(SessionManager != null, "SessionManager autoload is not registered!")
	assert(GameEvents != null, "GameEvents autoload is not registered!")
	print("✓ Autoload singletons verified (SessionManager, GameEvents).")
	
	# Load and test MainMenu
	var menu_scene: PackedScene = load("res://scenes/main_menu/MainMenu.tscn")
	assert(menu_scene != null, "Could not load MainMenu.tscn")
	var menu = menu_scene.instantiate()
	add_child(menu)
	print("✓ MainMenu.tscn instantiated and added to tree.")
	
	# Verify components
	var play_btn: Button = menu.get_node("%PlayButton")
	var salon_btn: Button = menu.get_node("%SalonButton")
	var settings_btn: Button = menu.get_node("%SettingsButton")
	var exit_btn: Button = menu.get_node("%ExitButton")
	var auth_modal: Control = menu.get_node("%AuthModal")
	var salon_modal: Control = menu.get_node("%SalonModal")
	var settings_modal: Control = menu.get_node("%SettingsModal")
	
	assert(play_btn != null and salon_btn != null and settings_btn != null and exit_btn != null)
	assert(auth_modal != null and salon_modal != null and settings_modal != null)
	print("✓ All menu buttons and modals detected.")
	
	# Test Play button -> Auth modal
	assert(auth_modal.visible == false, "AuthModal should start hidden")
	menu._on_play_pressed()
	assert(auth_modal.visible == true, "AuthModal should become visible on Play")
	print("✓ Play button opens AuthModal.")
	
	# Test Close AuthModal
	auth_modal.close_modal()
	assert(auth_modal.visible == false, "AuthModal should close")
	print("✓ Close button hides AuthModal.")
	
	# Test Salon modal
	menu._on_salon_pressed()
	assert(salon_modal.visible == true, "SalonModal should open")
	menu._on_close_salon_pressed()
	assert(salon_modal.visible == false, "SalonModal should close")
	print("✓ Salon modal opens and closes.")
	
	# Test Settings modal
	menu._on_settings_pressed()
	assert(settings_modal.visible == true, "SettingsModal should open")
	menu._on_close_settings_pressed()
	assert(settings_modal.visible == false, "SettingsModal should close")
	print("✓ Settings modal opens and closes.")
	
	# Test Guest Mode workflow
	menu._on_play_pressed()
	var guest_input: LineEdit = auth_modal.get_node("%GuestNameInput")
	guest_input.text = "HanaDoll"
	auth_modal._on_enter_guest_pressed()
	
	assert(SessionManager.is_logged_in == true, "SessionManager should be logged in")
	assert(SessionManager.is_guest == true, "SessionManager should flag is_guest")
	assert(SessionManager.username == "HanaDoll", "SessionManager username should match")
	print("✓ Guest mode successfully created session for: " + SessionManager.username + " (ID: " + SessionManager.user_id + ")")
	
	# Test prototypes/main.tscn scene integrity
	var main_scene: PackedScene = load("res://prototypes/main.tscn")
	assert(main_scene != null, "Could not load prototypes/main.tscn")
	var world = main_scene.instantiate()
	add_child(world)
	print("✓ prototypes/main.tscn loaded and instantiated.")
	
	var col_shape: CollisionShape3D = world.get_node("StaticBody3D/CollisionShape3D")
	var box: BoxShape3D = col_shape.shape as BoxShape3D
	assert(box.size == Vector3(20, 0.2, 20), "Floor collision must be 20x0.2x20")
	print("✓ Floor collision verified: " + str(box.size))
	
	var light: DirectionalLight3D = world.get_node("DirectionalLight3D")
	var env: WorldEnvironment = world.get_node("WorldEnvironment")
	var cam: Camera3D = world.get_node("Camera3D")
	assert(light != null and env != null and cam != null, "Lighting, environment, and camera verified")
	print("✓ Lighting, Environment, and Camera confirmed in prototypes/main.tscn.")
	
	var hud_badge: Label = world.get_node("%SessionBadge")
	assert(hud_badge != null, "HUD SessionBadge exists")
	print("✓ HUD displaying active session: " + hud_badge.text)
	
	print("\n==================================================")
	print("  ALL PHASE 1A TESTS COMPLETED SUCCESSFULLY! ")
	print("==================================================\n")
	get_tree().quit(0)
