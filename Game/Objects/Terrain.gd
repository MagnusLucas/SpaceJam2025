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
	print_debug("this should be first")
	for letter in used_name:
		terrain.affected_letters[letter] = true
	terrain.used_name = used_name
	terrain.effect = effect
	
	const A_OFFSET : int = 95
	terrain.set_collision_layer_value(1, true)
	for letter : String in terrain.affected_letters.keys():
		var unicode = letter.unicode_at(0) - A_OFFSET
		terrain.set_collision_layer_value(unicode, true)
		terrain.set_collision_mask_value(unicode, true)
	return terrain

func _ready() -> void:
	if used_name == "base":
		$"../Enemy/Marker2D".position = position
	if effect == EffectType.STOP:
		$StaticBody2D.process_mode = Node.PROCESS_MODE_INHERIT
	for layer in range(32):
		$StaticBody2D.set_collision_layer_value(layer + 1, get_collision_layer_value(layer + 1))
		$StaticBody2D.set_collision_mask_value(layer + 1, get_collision_mask_value(layer + 1))


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy and effect == EffectType.SLOW:
		body.speed *= .1
	elif body is Enemy and effect == EffectType.KILL:
		if self.used_name == "base":
			$"../".health -= 10
			$"../".update_health()
		body.queue_free()
	if body is Enemy and effect == EffectType.STOP:
		body.speed *= 0


func _on_body_exited(body: Node2D) -> void:
	if body is Enemy and effect == EffectType.SLOW:
		body.speed *= 10
