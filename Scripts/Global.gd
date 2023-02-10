extends Node

# I took a lot of inspiration from Sharkalien's Godot walkaround project.
# (https://github.com/Sharkalien/Godot-YOU-THERE.-BOY.-Walkaround)
# By that I mean I've totally just taken their code like a fucking goblin in some aspects. Sorry!
# Good learning experience though, never would've thought to do this otherwise lol,

# Here's a fun fact I was essentially going to do a RoomManager on every individual room to try and do what I wanted to do here.
# Thank fucking GOD I found out about autoloads and shit right at the same time lmao
# christ that wouldve been a fucking mess

enum InspectorMode { INSPECTABLE, CAPTCHABLE }
export(InspectorMode) var inspect_mode
var inspector_active : bool = true

onready var fade_effect = UI.get_node_or_null("FadeOverlay")
onready var sylladex = UI.get_node_or_null("Sylladex")
onready var dialogue = UI.get_node_or_null("DialogueBox")
# Sequences can be just about anything. Small cutscenes or animations, annoying walls of dialogue, triggering a popup, and the like.
# Obviously keeping track of when a sequence is active is good to be able to limit certain actions at certain times.
var sequence_active : bool = false
# continue_seq primarily for dialogue and whatnot.
var continue_sequence : bool = true

# Ok on second thought I'll split up sequences and dialogue to be independent; sequences might need to continue after dialogue ends
var dialog_active : bool = false
var continue_dialog : bool = true

var current_scene = null
var next_scene : String = ""

# To keep track of when the game has started its transition fade when moving to a new room
# Trans rights!
var scene_fading : bool = false
var fade_out : bool = false
var fade_tween

var player_node
var warp_path : String
var warp_target

# When Global is loaded, we create a Tween node to use for the fade effect, then connect its signal accordingly
# Since Global is created when the game first starts, we'll need to set the current_scene manually as well
# By checking for the last child of the scene tree's root. Then call find_nodes_in_room etc etc
func _ready():
	fade_tween = Tween.new()
	add_child(fade_tween)
	fade_tween.connect("tween_completed", self, "_on_fade_completed")
	scene_fading = true
	var fade_speed = 0.25
	fade_effect.visible = true
	fade_tween.interpolate_property(fade_effect, "color", Color(0,0,0,1), Color(0,0,0,0), fade_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fade_tween.start()
	
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	find_nodes_in_room()

# Get the player node and a warp target to move the player to, if warp_target exists.
# warp_target is defined by warp_path, which is set in the initial scene change function, start_room_transition
func find_nodes_in_room():
	player_node = current_scene.get_node_or_null("Player")
	if !player_node:
		player_node = current_scene.get_node_or_null("YSort/Player")
	
	if !warp_target:
		warp_target = current_scene.get_node_or_null(warp_path)
	
	if player_node:
		print("player found in room")
	if warp_target:
		print("warp target found in room")

# Start by enabling a sequence so nothing else can happen while the scene changes.
# This function is called by a Transitionable, which passes in its room_path and warp_to values.
# Sets the warp_path, then the next_scene, then starts a Tween node that fades out an overlay on the UI.
func start_room_transition(room, warp):
	sequence_active = true
	
	if !warp.empty():
		warp_path = warp
	
	next_scene = room
	
	var fade_speed = 0.25
	scene_fading = true
	fade_tween.interpolate_property(fade_effect, "color", Color(0,0,0,0), Color(0,0,0,1), fade_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fade_tween.start()

# Since this is called when the Tween completes, it will do one of two things:
# If we're fading out, then that means we're transitioning to the next scene. Call scene_transition and fade again
# but this time fade_out is false, so when it completes again we just reset the other variables back to normal and move on
func _on_fade_completed(_object, _key):
	if scene_fading:
		if !fade_out:
			fade_out = true
			scene_fading = false
		else:
			fade_out = false
			scene_transition()
			var fade_speed = 0.25
			fade_tween.interpolate_property(fade_effect, "color", Color(0,0,0,1), Color(0,0,0,0), fade_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			fade_tween.start()

# Delay the scene load so that it only unloads the scene when the game is idle.
# Obviously if the current scene is still running code and it gets freed/changed, shit might not work as intended.
# A shrimple solution
func scene_transition():
	if !next_scene.empty():
		call_deferred("_change_to_room")

func _change_to_room():
	if current_scene:
		print("freed")
		current_scene.free()
	
	assert(ResourceLoader.load(next_scene), "Room path is incorrect! Check Transitionable for correct spelling of folder_path and room_name. Does the room even exist?")
	var new_room = ResourceLoader.load(next_scene)
	
	current_scene = new_room.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
	find_nodes_in_room()
	
	if warp_target:
		player_node.global_position = warp_target.get_position()
		warp_target = null
	
	# Since the camera's position gets updated by the player's RemoteTransform2D
	# you don't need to manually update it anymore. However, while the camera's
	# smoothing is enabled, this transformation will be noticeable when changing
	# rooms. Disabling it while transitioning will fix this, but idk how to 
	# re-enable it afterwards. YOU figure that out if you want
#	UI.camera.smoothing_enabled = false
#	UI.camera.global_position = player_node.remote_transform.global_position
	
	sequence_active = false
