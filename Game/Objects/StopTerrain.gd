extends Terrain
class_name StopTerrain

const a_offset : int = 95

@warning_ignore("shadowed_variable_base_class")
static func new_terrain(used_name : String) -> Terrain:
	var terrain = Terrain.new_terrain(used_name)
	terrain.set_collision_layer_value(1, true)
	for letter : String in terrain.affected_letters.keys():
		var unicode = letter.unicode_at(0) - a_offset
		terrain.set_collision_layer_value(unicode, true)
	return terrain
