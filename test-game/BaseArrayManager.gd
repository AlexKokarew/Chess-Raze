extends Node

class_name BaseArrayManager

# Основной массив, управляющий состоянием
var grid: Array = []

# Инициализация массива с заданным размером и значением по умолчанию
func initialize(size: int, default_value: Variant = false) -> void:
	grid.resize(size)
	for i in range(size):
		grid[i] = default_value

# Изменение размера массива (для двумерных массивов используется rows * columns)
func resize_array(rows: int, columns: int, default_value: Variant = false) -> void:
	var new_size = rows * columns
	grid.resize(new_size)
	for i in range(grid.size()):
		if grid[i] == null:
			grid[i] = default_value

# Обновление значения в указанной ячейке
func update_cell(index: int, value: Variant) -> void:
	if index >= 0 and index < grid.size():
		grid[index] = value

# Проверка, заполнена ли ячейка
func is_cell_filled(index: int) -> bool:
	return grid[index] if index >= 0 and index < grid.size() else false

# Очистка всего массива
func clear() -> void:
	for i in range(grid.size()):
		grid[i] = false

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

# Создание пустого n-мерного массива заданных размеров
func create_empty_array(dimensions: Array) -> Array:
	if dimensions.size() == 0:
		return []
	var result = []
	for i in range(dimensions[0]):
		result.append(create_empty_array(dimensions.slice(1)))
	return result

# Генерация всех координат для n-мерного массива
func generate_coords(dimensions: Array) -> Array:
	if dimensions.size() == 0:
		return []

	var coords = [[]]
	for dim in dimensions:
		var new_coords = []
		for coord in coords:
			for i in range(dim):
				new_coords.append(coord + [i])
		coords = new_coords
	return coords
