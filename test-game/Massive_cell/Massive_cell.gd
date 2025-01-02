extends Node

const ARRAY_SIZE = 100
var bit_array: Array = []
var filled_indices: Array = []

func _ready():
	bit_array.resize(ARRAY_SIZE) # Инициализация битового массива
	for i in range(ARRAY_SIZE):
		bit_array[i] = false  # Изначально все ячейки пустые
		
	
	
func _on_timer_timeout() -> void:
	for i in range(ARRAY_SIZE):
		if bit_array[i]:  # Если ячейка заполнена
			if !is_cell_filled(i):  # Проверка, заполнена ли ячейка
				filled_indices.erase(i)  # Удаляем индекс из массива заполненных ячеек
		else:
			if i in filled_indices:  # Если ячейка была заполнена, но теперь пустая
				filled_indices.erase(i)  # Удаляем индекс из массива заполненных ячеек
	
	update_cell(0, true)
	
	var testcell = is_cell_filled(0)
	print(testcell)
	var testcell2 = is_cell_filled(1)
	print(testcell2)
	var testcell3 = is_cell_filled(2)
	print(testcell3)

func is_cell_filled(index: int) -> bool:
	if index < 0 or index >= ARRAY_SIZE:
		pass
	return bit_array[index]  # Проверяем состояние ячейки в битовом массиве

func update_cell(index: int, state: bool):
	bit_array[index] = state  # Обновляем состояние ячейки
	if state and not filled_indices.has(index):
		filled_indices.append(index)  # Добавляем индекс в массив, если ячейка заполнена
	elif not state and filled_indices.has(index):
		filled_indices.erase(index)  # Удаляем индекс, если ячейка стала пустой
