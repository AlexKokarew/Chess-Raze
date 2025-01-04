
# Конь
class_name Knight
extends "res://class_figyr/base_figyra.gd"

func get_valid_moves(board_size: int) -> Array:
	var moves = []
	var knight_moves = [
		Vector2(2, 1), Vector2(2, -1), Vector2(-2, 1), Vector2(-2, -1),
		Vector2(1, 2), Vector2(1, -2), Vector2(-1, 2), Vector2(-1, -2)
	]
	for move in knight_moves:
		var new_position = position + move
		if new_position.x >= 0 and new_position.x < board_size and new_position.y >= 0 and new_position.y < board_size:
			moves.append(new_position)
	return moves
