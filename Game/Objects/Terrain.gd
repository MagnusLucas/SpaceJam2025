extends Area2D
class_name Terrain

@export var image_atlas_coords = Vector2i(-1, -1)
@export var object_names : Array[String]

const collision_scene = preload("res://Game/Objects/terrain.tscn")

var used_name : String
var affected_letters : Dictionary
var effect : EffectType

enum EffectType{
	STOP,
	SLOW,
	KILL
}

@warning_ignore("shadowed_variable")
static func new_terrain(used_name : String, effect : EffectType) -> Terrain:
	var terrain = collision_scene.instantiate()
	for letter in used_name:
		terrain.affected_letters[letter] = true
	terrain.used_name = used_name
	
	const A_OFFSET : int = 95
	terrain.set_collision_layer_value(1, true)
	for letter : String in terrain.affected_letters.keys():
		var unicode = letter.unicode_at(0) - A_OFFSET
		terrain.set_collision_layer_value(unicode, true)
	return terrain
