extends Node

var grid = []  # Исходный массив

# Функция для изменения размера массива
func resize_array(rows: int, columns: int) -> void:
	var new_size = rows * columns
	# Уменьшаем или увеличиваем массив
	if new_size < grid.size():
		# Удаляем лишние элементы
		grid.resize(new_size)  # Элементы будут удалены
	elif new_size > grid.size():
		# Добавляем новые элементы
		for i in range(grid.size(), new_size):
			grid.append(false)  # Добавляем новые ячейки с значением false

# Пример использования
func _ready():
	# Инициализация массива 10x10
	resize_array(10, 10)
	print(grid)  # Выводит массив из 100 ячеек

	# Изменение размера массива на 5x5
	resize_array(5, 5)
	print(grid)  # Выводит массив из 25 ячеек, остальные ячейки будут удалены
