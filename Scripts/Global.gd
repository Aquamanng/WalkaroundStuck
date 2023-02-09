extends Node

# I took a lot of inspiration from Sharkalien's Godot walkaround project.
# (https://github.com/Sharkalien/Godot-YOU-THERE.-BOY.-Walkaround)
# By that I mean I've totally just taken their code like a fucking goblin in some aspects. Sorry!
# Good learning experience though, never would've thought to do this otherwise lol
# Scripts will call functions in Global whenever they need them; for instance,
# rooms will call init_room when they are finished loading in order to have Global find the player and set the current_scene as that room

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
var scene_fading : bool = false
var fade_out : bool = false
var fade_tween

var player_node
var warp_path : String
var warp_target

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

func start_room_transition(room, warp):
	sequence_active = true
	
	# maybe unnecessary? i think so but idk yet
	if !warp.empty():
		warp_path = warp
	
	next_scene = room
	
	var fade_speed = 0.25
	scene_fading = true
	fade_tween.interpolate_property(fade_effect, "color", Color(0,0,0,0), Color(0,0,0,1), fade_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fade_tween.start()

func _on_fade_completed(_object, _key):
	if scene_fading:
		if fade_out:
			fade_out = false
			scene_fading = false
		else:
			fade_out = true
			scene_transition()
			var fade_speed = 0.25
			fade_tween.interpolate_property(fade_effect, "color", Color(0,0,0,1), Color(0,0,0,0), fade_speed, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			fade_tween.start()

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
	
	player_node.cam.global_position = player_node.global_position
	
	sequence_active = false
