# ChessUtils.gd
extends Node
class_name ChessUtilities

# Универсальная функция для вычисления новой позиции по вектору смещения и количеству шагов
static func calculate_new_position(current_position: Vector2i, movement: Vector2i, steps: int) -> Vector2i:
	return current_position + movement * steps

# Функция для проверки, что позиция не выходит за границы доски
# Возвращает индекс ячейки или -1, если позиция некорректна
static func clamp_position(position: Vector2i, rows: int, columns: int) -> int:
	var clamped_x = clamp(position.x, 0, columns - 1)
	var clamped_y = clamp(position.y, 0, rows - 1)
	
	if clamped_x != position.x or clamped_y != position.y:
		push_error("Move out of bounds!")
		return -1  # или можно вернуть текущий индекс, если это логика игры
	return clamped_y * columns + clamped_x
