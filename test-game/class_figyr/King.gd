class_name King
extends "res://class_figyr/base_figyra.gd"

func get_valid_moves(board_size: int) -> Array:
	var moves = []
	for x in range(-1, 2):  # Правильный диапазон от -1 до 1 включительно
		for y in range(-1, 2):
			if x == 0 and y == 0:
				continue  # Пропустить текущую позицию
			var new_position = position + Vector2(x, y)
			if new_position.x >= 0 and new_position.x < board_size and new_position.y >= 0 and new_position.y < board_size:
				moves.append(new_position)
	return moves
