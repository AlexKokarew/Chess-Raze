extends Node

# Сохранение состояния игры
func save_game(attacker, defender):
	# Проверка, что объекты инициализированы
	if not attacker or not defender:
		print("Error: Game state objects not initialized.")
		return

	# Создание словаря состояния
	var state = {
		"attacker": {"position": attacker.position, "health": attacker.health},
		"defender": {"position": defender.position, "health": defender.health}
	}

	# Преобразование словаря в строку JSON
	var json_state = JSON.new().print(state)

	# Сохранение строки JSON в файл
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		file.store_string(json_state)
		file.close()
		print("Game saved.")
	else:
		print("Error: Unable to save game.")

# Загрузка состояния игры
func load_game(attacker, defender):
	if FileAccess.file_exists("user://savegame.json"):
		var file = FileAccess.open("user://savegame.json", FileAccess.READ)
		if file:
			# Чтение строки JSON из файла
			var json_state = file.get_as_text()
			file.close()

			# Преобразование строки JSON обратно в словарь
			var parse_result = JSON.new().parse(json_state)
			if parse_result.error != OK:
				print("Error parsing JSON:", parse_result.error_string)
				return

			var state = parse_result.result

			# Применение состояния
			attacker.position = state["attacker"]["position"]
			attacker.health = state["attacker"]["health"]

			defender.position = state["defender"]["position"]
			defender.health = state["defender"]["health"]

			print("Game loaded.")
		else:
			print("Error: Unable to open save file.")
	else:
		print("Error: Save file does not exist.")

# Преобразование n-мерных координат в одномерный индекс
func to_index(coords: Array, dimensions: Array) -> int:
	var index = 0
	var stride = 1
	for i in range(coords.size() - 1, -1, -1):
		index += coords[i] * stride
		stride *= dimensions[i]
	return index

# Преобразование одномерного индекса в n-мерные координаты
func from_index(index: int, dimensions: Array) -> Array:
	var coords = []
	for i in range(dimensions.size() - 1, -1, -1):
		coords.insert(0, index % dimensions[i])
		index = index / dimensions[i]
	return coords

# Сохранение массива в одномерном виде
func flatten_array(array: Array, dimensions: Array) -> Array:
	if dimensions.size() == 0: # Исправлено использование empty()
		print("Error: dimensions array is empty.")
		return []

	var flat_array = []
	for coords in generate_coords(dimensions):
		flat_array.append(get_element(array, coords))
	return flat_array

# Восстановление массива из одномерного представления
func reconstruct_array(flat_array: Array, dimensions: Array) -> Array:
	var reconstructed = create_empty_array(dimensions)
	for index in range(flat_array.size()):
		var coords = from_index(index, dimensions)
		set_element(reconstructed, coords, flat_array[index])
	return reconstructed

# Генерация всех координат для n-мерного массива
func generate_coords(dimensions: Array) -> Array:
	if dimensions.size() == 0: # Возврат пустого массива вместо null
		return []

	var coords = [[]]
	for dim in dimensions:
		var new_coords = []
		for coord in coords:
			for i in range(dim):
				new_coords.append(coord + [i])
		coords = new_coords
	return coords

# Получение элемента из n-мерного массива
func get_element(array: Array, coords: Array) -> Variant:
	var current = array
	for coord in coords:
		current = current[coord]
	return current

# Установка элемента в n-мерный массив
func set_element(array: Array, coords: Array, value: Variant):
	var current = array
	for i in range(coords.size() - 1):
		current = current[coords[i]]
	current[coords[-1]] = value

# Создание пустого n-мерного массива заданных размеров
func create_empty_array(dimensions: Array) -> Array:
	if dimensions.size() == 0: # Возврат пустого массива вместо null
		return []
	var result = []
	for i in range(dimensions[0]):
		result.append(create_empty_array(dimensions.slice(1)))
	return result

# Сохранение данных в файл
func save_arrays(arrays: Dictionary, filepath: String):
	var data = {}
	for array_name in arrays.keys():
		var array = arrays[array_name]
		var dimensions = array["dimensions"]
		var flat_array = flatten_array(array["data"], dimensions)
		data[array_name] = {
			"dimensions": dimensions,
			"flat_data": flat_array
		}
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	if file:
		file.store_string(JSON.new().print(data))
		file.close()
		print("Data saved to:", filepath)
	else:
		print("Failed to save data.")

# Загрузка данных из файла
func load_arrays(filepath: String) -> Dictionary:
	if FileAccess.file_exists(filepath): # Исправлено вызов file_exists
		var file = FileAccess.open(filepath, FileAccess.READ)
		if file:
			var parse_result = JSON.new().parse(file.get_as_text())
			if parse_result.error != OK:
				print("Error parsing JSON:", parse_result.error_string)
				return {}

			var data = parse_result.result
			file.close()
			var arrays = {}
			@warning_ignore("shadowed_variable_base_class")
			for array_name in data.keys():
				var dimensions = data[array_name]["dimensions"]
				var flat_array = data[array_name]["flat_data"]
				arrays[array_name] = {
					"dimensions": dimensions,
					"data": reconstruct_array(flat_array, dimensions)
				}
			print("Data loaded from:", filepath)
			return arrays
		else:
			print("Failed to open file.")
	else:
		print("File does not exist:", filepath)
	return {}
