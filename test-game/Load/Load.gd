extends Node

func load_game():
	var file = File.new()
	if file.file_exists("user://savegame.json"):
		file.open("user://savegame.json", File.READ)
		var state = parse_json(file.get_as_text())
		file.close()
		
		if state.has("attacker") and state.has("defenders"):
			attacker.position = state["attacker"]["position"]
			attacker.health = state["attacker"]["health"]
			
			defender1.position = state["defenders"][0]["position"]
			defender1.health = state["defenders"][0]["health"]
			
			defender2.position = state["defenders"][1]["position"]
			defender2.health = state["defenders"][1]["health"]
			
			print("Game loaded.")
		else:
			print("Error: Invalid save data.")
	else:
		print("Save file not found.")
