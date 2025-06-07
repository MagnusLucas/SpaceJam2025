extends Area2D
class_name Terrain

@export var image_atlas_coords = Vector2i(-1, -1)
@export var object_names : Array[String]

const collision_scene = preload("res://Game/Objects/terrain.tscn")

var used_name : String
var affected_letters : Dictionary
var effect : EffectType
var movable : bool = true

enum EffectType{
	STOP,
	SLOW,
	KILL
}

func _ready() -> void:
	if used_name == 'base':
		$Polygon2D.color='b246ff78'
	elif effect == EffectType.SLOW:
		$Polygon2D.color='00ff0078'
	elif effect == EffectType.KILL:
		$Polygon2D.color='ff000078'
	elif effect == EffectType.STOP:
		$Polygon2D.color='0000ff78'
	$Label.text = used_name
@warning_ignore("shadowed_variable")
static func new_terrain(used_name : String, effect : EffectType) -> Terrain:
	var terrain = collision_scene.instantiate()
	if used_name == 'base':
		for letter in 'abcdefghijklmnopqrstuvwxyz':
			terrain.affected_letters[letter] = true
	else:
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

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy and effect == EffectType.SLOW:
		body.speed *= .1
	elif body is Enemy and effect == EffectType.KILL:
		if self.used_name == "base":
			$"../".health -= 50
			$"../".update_health()
		body.queue_free()
	if body is Enemy and effect == EffectType.STOP:
		body.speed *= 0


func _on_body_exited(body: Node2D) -> void:
	if body is Enemy and effect == EffectType.SLOW:
		body.speed *= 10


func _on_mouse_entered() -> void:
	print("showing")
	$Label.show()


func _on_mouse_exited() -> void:
	$Label.hide()
