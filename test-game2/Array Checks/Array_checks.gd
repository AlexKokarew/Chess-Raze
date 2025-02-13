extends Node

class_name ArrayChecks

# Проверка валидности индекса
static func validate_index(index: int, size: int) -> bool:
	return index >= 0 and index < size



# Преобразование двумерных координат в одномерный индекс
static func to_index(coords: Vector2i, columns: int) -> int:
	return coords.y * columns + coords.x

# Проверка, находится ли координата в пределах поля
static func is_within_bounds(coords: Vector2i, rows: int, columns: int) -> bool:
	return 0 <= coords.x and coords.x < columns and 0 <= coords.y and coords.y < rows

# Генерация всех координат для массива
static func generate_coords(rows: int, columns: int) -> PackedVector2Array:
	var coords = PackedVector2Array()
	for y in range(rows):
		for x in range(columns):
			coords.append(Vector2i(x, y))
	return coords

# Преобразование одномерного массива в двумерный
static func reshape_to_2d(array: Array, rows: int, columns: int) -> Array:
	if array.size() != rows * columns:
		print("Размер массива не соответствует заданным размерам: ", rows, "x", columns)
		return []  # Возвращаем пустой массив, если размеры не совпадают

	var result = []
	for y in range(rows):
		var row = []
		for x in range(columns):
			var index = to_index(Vector2i(x, y), columns)
			row.append(array[index] if index < array.size() else null)
		result.append(row)
	return result

# Преобразование двумерного массива в одномерный
static func flatten_to_1d(array: Array) -> Array:
	var result = []
	for row in array:
		result += row
	return result

# Проверка корректности размеров массива
static func validate_dimensions(rows: int, columns: int, size: int) -> bool:
	return rows * columns == size
