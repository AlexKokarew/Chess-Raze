extends Node

class_name BaseArrayManager


# Основной массив данных (одноразмерный массив, представляющий доску)
var grid = []
var rows = 0
var columns = 0

# Инициализация массива
func initialize_grid(new_rows: int, new_columns: int):
	rows = new_rows
	columns = new_columns
	grid.resize(rows * columns)
	for i in range(grid.size()):
		grid[i] = 0  # Пустая ячейка
	print("Массив инициализирован: ", grid)

# Получение размеров массива
func get_dimensions() -> Dictionary:
	return {"rows": rows, "columns": columns}

# Проверка валидности индекса
func validate_index(index: int) -> bool:
	return index >= 0 and index < grid.size()

# Преобразование индекса в координаты
func from_index(index: int) -> Array:
	if not validate_index(index):
		return [-1, -1]  # Возвращаем -1, -1, если индекс недопустим
	var row = index / columns  # Целочисленное деление
	var column = index % columns
	return [row, column]  # Возвращаем массив из двух значений
	
# Преобразование координат в индекс
func to_index(row: int, column: int) -> int:
	if row < 0 or row >= rows or column < 0 or column >= columns:
		return -1
	return row * columns + column

# Обновление ячейки массива
func update_cell(index: int, value: int):
	if validate_index(index):
		grid[index] = value
		print("Ячейка обновлена: ", index, "=>", value)
	else:
		print("Ошибка: индекс за пределами массива.")

# Получение значения ячейки
func get_cell_value(index: int) -> int:
	if validate_index(index):
		return grid[index]
	print("Ошибка: индекс за пределами массива.")
	return 0

# Получение всех фигур
func get_all_pieces() -> Array:
	var pieces = []
	for i in range(grid.size()):
		if grid[i] != 0:  # Проверяем, не пустая ли ячейка
			pieces.append(grid[i])
	return pieces


# Синхронизация состояний после атаки
func update_grid_from_logick_attack(updated_pieces: Array):
	for piece in updated_pieces:
		update_cell(piece.index, piece)

# Сохранение состояния массива
func save_grid_state() -> Dictionary:
	return {
		"grid": grid.duplicate(),
		"rows": rows,
		"columns": columns
	}

# Загрузка состояния массива
func load_grid_state(state: Dictionary):
	if state.has("grid") and state.has("rows") and state.has("columns"):
		grid = state["grid"]
		rows = state["rows"]
		columns = state["columns"]
		print("Состояние массива загружено.")
	else:
		print("Ошибка: некорректное состояние массива.")

# Логирование текущего состояния массива
func log_grid_state():
	print("Текущее состояние массива:")
	for row in range(rows):
		var line = ""
		for column in range(columns):
			var index = to_index(row, column)
			line += grid[index] + " "
		print(line.strip())
