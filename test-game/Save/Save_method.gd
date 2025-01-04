extends Node



func save_game():
	var state = {
		"attacker": {"position": attacker.position, "health": attacker.health},
		"defenders": [
			{"position": defender1.position, "health": defender1.health},
			{"position": defender2.position, "health": defender2.health}
		]
	}
	var file = File.new()
	file.open("user://savegame.json", File.WRITE)
	file.store_string(to_json(state))
	file.close()
	print("Game saved.")

func load_game():
	var file = File.new()
	if file.file_exists("user://savegame.json"):
		file.open("user://savegame.json", File.READ)
		var state = parse_json(file.get_as_text())
		file.close()

		attacker.position = state["attacker"]["position"]
		attacker.health = state["attacker"]["health"]

		defender1.position = state["defenders"][0]["position"]
		defender1.health = state["defenders"][0]["health"]

		defender2.position = state["defenders"][1]["position"]
		defender2.health = state["defenders"][1]["health"]

		print("Game loaded.")
